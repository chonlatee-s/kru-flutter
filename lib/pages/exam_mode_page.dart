import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kru/store/app_store.dart';

class ExamModePage extends StatelessWidget {
  const ExamModePage({super.key});

  static const Color brandGold = Color(0xFFB9976C);
  static const Color brandNavy = Color(0xFF2D2F31);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: brandNavy),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'เลือกโหมดการสอบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
            color: brandNavy,
          ),
        ),
        actions: [
          // แสดงปุ่ม Logout เฉพาะเมื่อเข้าสู่ระบบแล้ว
          ListenableBuilder(
            listenable: userChanged,
            builder: (context, child) {
              if (currentUser == null) return const SizedBox();
              return IconButton(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout, color: Color.fromARGB(255, 59, 59, 59)),
                tooltip: 'ออกจากระบบ',
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- โหมดแข่งขัน (ใช้ ListenableBuilder เพื่อเปลี่ยน UI ทันทีที่ล็อกอิน) ---
            ListenableBuilder(
              listenable: userChanged,
              builder: (context, child) {
                bool isLoggedIn = currentUser != null;
                return _buildModeCard(
                  context,
                  title: isLoggedIn 
                      ? 'โหมดแข่งขัน' 
                      : 'โหมดแข่งขัน',
                  subtitle: isLoggedIn
                      ? 'คุณเข้าสู่ระบบในชื่อ: ${currentUser!['name']}'
                      : 'สุ่ม 20 ข้อจากทุกหมวดหมู่ (ต้องล็อกอินเพื่อเก็บคะแนน)',
                  icon: isLoggedIn ? Icons.emoji_events : Icons.emoji_events,
                  color: brandNavy,
                  onTap: () async {
                    if (!isLoggedIn) {
                      // ถ้ายังไม่ล็อกอิน ให้แสดง Loading ระหว่างรอ Google Popup
                      _showLoading(context);
                      await loginWithGoogle(context);
                      if (context.mounted) Navigator.pop(context); // ปิด Loading
                    }

                    // ถ้าล็อกอินสำเร็จแล้ว (หรือเดิมล็อกอินอยู่แล้ว) ให้ไปหน้าสอบ
                    if (currentUser != null && context.mounted) {
                      print("DEBUG: กำลังส่งค่า mode = exam ไปยัง Router");
                      getTesting(mode: 'exam');
                      context.push('/testing?mode=exam');
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            // --- โหมดฝึกฝน ---
            _buildModeCard(
              context,
              title: 'โหมดฝึกฝน',
              subtitle: 'ฝึกทำ 10 ข้อ เจาะจงเฉพาะหมวดหมู่ที่คุณต้องการ',
              icon: Icons.auto_stories,
              color: brandGold,
              onTap: () => _showCategoryPicker(context),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget สำหรับหน้ากากเลือกโหมด ---
  Widget _buildModeCard(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
          border: Border.all(
            color: color == brandNavy && currentUser != null 
                ? brandGold.withOpacity(0.5) 
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- BottomSheet เลือกหมวดหมู่ ---
  void _showCategoryPicker(BuildContext context) {
    getCategories();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return ListenableBuilder(
                listenable: categoriesChanged,
                builder: (context, child) {
                  if (categories.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: brandGold));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 20),
                        const Text('เลือกหมวดหมู่ที่ต้องการฝึก',
                            style: TextStyle(fontFamily: 'Kanit', fontSize: 18, fontWeight: FontWeight.bold)),
                        const Divider(height: 30),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 0,
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey[200]!),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.folder_open, color: brandGold),
                                  title: Text(categories[index]['name'], style: const TextStyle(fontFamily: 'Kanit')),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                                  onTap: () {
                                    getTesting(
                                        mode: 'practice', 
                                        categoryId: int.parse(categories[index]['id'].toString()));
                                    Navigator.pop(context);
                                    context.push('/testing?mode=practice');
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  // --- Helper Dialogs ---
  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: brandGold)),
    );
  }

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