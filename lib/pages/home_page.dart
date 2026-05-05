import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kru/store/app_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color brandGold = Color(0xFFB9976C);
  static const Color brandNavy = Color(0xFF2D2F31);
  static const Color bgColor = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    _initData();
  }

  // ฟังก์ชันเริ่มต้นข้อมูลเพื่อให้ระบบจำการ Login ได้ทันที
  Future<void> _initData() async {
    await checkLoginStatus(); // เช็คสถานะการล็อกอินจาก Shared Preferences
    getNews();
    getWord();
    getLeaderboard();
    
    // หากมีผู้ใช้ล็อกอินอยู่ ให้ดึงประวัติการสอบมารอไว้เลย
    if (currentUser != null) {
      getExamHistory();
    }
  }

  String formatBestTime(dynamic seconds) {
    if (seconds == null) return '0 วินาที';
    int totalSeconds = int.tryParse(seconds.toString()) ?? 0;
    
    if (totalSeconds < 60) {
      return '$totalSeconds วินาที';
    } else {
      int minutes = totalSeconds ~/ 60;
      int remainingSeconds = totalSeconds % 60;
      if (remainingSeconds == 0) {
        return '$minutes นาที';
      } else {
        return '$minutes นาที $remainingSeconds วินาที';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: ListenableBuilder(
          listenable: Listenable.merge([newsChanged, wordChanged, userChanged, leaderboardChanged]),
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. ข่าวประกาศ
                  if (news.isNotEmpty)
                    _buildAnnouncement(context, news[0]['news'] ?? '', news[0]['ref']),
                  
                  const SizedBox(height: 24),

                  // 2. ส่วนทักทาย (จะแสดงชื่อทันทีหาก Login ค้างไว้)
                  _buildHeaderSection(
                    currentUser != null ? 'ยินดีต้อนรับ, คุณ${currentUser!['name']}' : 'สวัสดีครับ, คุณครู',
                    word.isNotEmpty ? word : 'ขอเป็นกำลังใจให้สอบผ่านนะครับ'
                  ),
                  
                  const SizedBox(height: 24),

                  // 3. ส่วน Banner สนามสอบจำลอง
                  _buildMainCTA(context),
                  
                  const SizedBox(height: 32),

                  // 4. ส่วนเมนูบริการ
                  const Text('บริการทั้งหมด', style: TextStyle(fontFamily: 'Kanit', fontSize: 18, fontWeight: FontWeight.w700, color: brandNavy)),
                  const SizedBox(height: 16),
                  _buildServiceGrid(context),

                  const SizedBox(height: 32),

                  // 5. ส่วนทำเนียบคนเก่ง
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      const Text('ทำเนียบคนเก่ง', style: TextStyle(fontFamily: 'Kanit', fontSize: 18, fontWeight: FontWeight.w700, color: brandNavy)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLeaderboard(),
                  
                  const SizedBox(height: 100), 
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/exam-mode'),
        backgroundColor: brandGold,
        elevation: 4,
        child: const Icon(Icons.edit_document, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  // --- UI COMPONENTS ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Image.asset('assets/img/logo_home.png', width: 30),
          const SizedBox(width: 12),
          const Text('ครูผู้ช่วย', style: TextStyle(fontFamily: 'Kanit', fontSize: 22, fontWeight: FontWeight.bold, color: brandGold)),
        ],
      ),
      actions: [
        if (currentUser != null)
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(currentUser!['picture'] ?? ''),
                onBackgroundImageError: (_, __) => const Icon(Icons.person),
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Color.fromARGB(255, 59, 59, 59)),
                onPressed: () => _confirmLogout(context), // ปรับให้เหมือน exam_mode
              ),
            ],
          )
        else
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: brandNavy, size: 28),
            onPressed: () => context.push('/exam-mode'),
          ),
      ],
    );
  }

  Widget _buildHeaderSection(String greeting, String quote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting, style: const TextStyle(fontFamily: 'Kanit', fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(quote, style: const TextStyle(fontFamily: 'Kanit', fontSize: 22, fontWeight: FontWeight.bold, color: brandNavy, height: 1.2)),
      ],
    );
  }

  Widget _buildMainCTA(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color.fromARGB(255, 69, 89, 177), Color.fromARGB(255, 117, 114, 190)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Color.fromARGB(255, 144, 182, 240), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('สนามสอบจำลอง', style: TextStyle(fontFamily: 'Kanit', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('สุ่มข้อสอบ, จับเวลา, รู้ผลทันที', style: TextStyle(fontFamily: 'Kanit', fontSize: 14, color: Colors.white)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push('/exam-mode'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Color.fromARGB(255, 1, 78, 150), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('เริ่มสอบเลย', style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const Icon(Icons.psychology, color: Colors.white, size: 60),
        ],
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEEEEEE))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMenuItem(context, Icons.auto_awesome, 'เสี่ยงทาย', path: '/predict'),
          _buildMenuItem(context, Icons.search, 'หางาน', path: '/job'),
          _buildMenuItem(
            context, 
            Icons.history, 
            'ประวัติสอบ', 
            onTap: () {
              if (currentUser != null) {
                context.push('/history');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กรุณาเข้าสู่ระบบเพื่อดูประวัติ', style: TextStyle(fontFamily: 'Kanit')), behavior: SnackBarBehavior.floating),
                );
                context.push('/exam-mode');
              }
            }
          ),
          _buildMenuItem(context, Icons.coffee, 'เลี้ยงชานม', path: '/pay'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, {String? path, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () { if (path != null) context.push(path); },
      child: SizedBox(
        width: 75,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFFF1E4CF), shape: BoxShape.circle),
              child: Icon(icon, color: brandGold, size: 26),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontFamily: 'Kanit', fontSize: 12, fontWeight: FontWeight.w500, color: brandNavy), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard() {
    if (leaderboard.isEmpty) return const Center(child: Text('กำลังโหลด...', style: TextStyle(fontFamily: 'Kanit')));
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEEEEEE))),
      child: Column(
        children: leaderboard.asMap().entries.map((entry) {
          int index = entry.key;
          var user = entry.value;
          Color medalColor = index == 0 ? Colors.amber : (index == 1 ? Colors.grey : (index == 2 ? Colors.brown : Colors.transparent));
          return ListTile(
            leading: Badge(
              label: Text('${index + 1}'),
              backgroundColor: medalColor,
              isLabelVisible: index < 3,
              child: CircleAvatar(backgroundImage: NetworkImage(user['google_profile_pic'] ?? '')),
            ),
            title: Text(user['user_name'], style: const TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
            subtitle: Text('เวลาที่ดีที่สุด: ${formatBestTime(user['best_time'])}', style: const TextStyle(fontSize: 11, fontFamily: 'Kanit')),
            trailing: Text('${user['top_score']}', style: const TextStyle(fontFamily: 'Kanit', fontSize: 18, fontWeight: FontWeight.bold, color: brandGold)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnnouncement(BuildContext context, String text, String? url) {
    return InkWell(
      onTap: () { if (url != null && url != '?') launchUrl(Uri.parse(url)); },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            const Icon(Icons.campaign, color: Colors.green, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontFamily: 'Kanit', fontSize: 13, color: Colors.green), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      height: 70,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.home_filled, color: brandNavy), Text('หน้าหลัก', style: TextStyle(fontFamily: 'Kanit', fontSize: 10, color: brandNavy))]),
          const SizedBox(width: 40), 
          InkWell(
            onTap: () => context.go('/aboutUs'),
            child: const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.person, color: Colors.grey), Text('ผู้พัฒนา', style: TextStyle(fontFamily: 'Kanit', fontSize: 10, color: Colors.grey))]),
          ),
        ],
      ),
    );
  }

  // ปรับปรุงข้อความ Dialog ให้เหมือนกันกับ ExamModePage
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ออกจากระบบ?', style: TextStyle(fontFamily: 'Kanit')),
        content: const Text('คุณต้องการออกจากระบบ Google ใช่หรือไม่?', style: TextStyle(fontFamily: 'Kanit')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          TextButton(
            onPressed: () {
              logout();
              Navigator.pop(context);
            },
            child: const Text('ยืนยัน', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}