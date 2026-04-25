import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  static const Color brandGold = Color(0xFFB9976C);
  static const Color brandNavy = Color(0xFF2D2F31);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 240.0,
            pinned: true,
            elevation: 0,
            backgroundColor: brandNavy,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => context.go('/home'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/img/about.jpg', 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [brandNavy, Color(0xFF4A4D50)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(Icons.person, size: 80, color: Colors.white24),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, brandNavy.withOpacity(0.8)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Transform.translate(
              // 🔴 จุดแก้ไข 1: ปรับ offset ให้กล่องตกลงมา (จาก -30 เป็น -15 หรือ 0)
              offset: const Offset(0, 15), 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('ประวัติการศึกษา', Icons.school_outlined),
                    _buildEducationContent(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('ประสบการณ์ทำงาน', Icons.work_outline_rounded),
                    _buildWorkContent(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('ความเชี่ยวชาญ & ผลงาน', Icons.verified_outlined),
                    _buildExpertiseContent(),
                    const SizedBox(height: 40),
                    const Opacity(
                      opacity: 0.5,
                      child: Text('ครูผู้ช่วย.com', style: TextStyle(fontFamily: 'Kanit', fontSize: 12)),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/exam-mode'),
        backgroundColor: brandGold,
        elevation: 4,
        child: const Icon(Icons.edit_document, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // 🔴 จุดแก้ไข 2: ปรับปรุง BottomAppBar เพื่อแก้ RenderFlex Overflow
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          const Text(
            'ชลธี สินสาตร์',
            style: TextStyle(fontFamily: 'Kanit', fontSize: 24, fontWeight: FontWeight.bold, color: brandNavy),
          ),
          const SizedBox(height: 4),
          const Text(
            'การศึกษาคือรากฐานของชีวิต',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Kanit', fontSize: 13, color: brandGold),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
          ),
          _buildInfoRow(Icons.alternate_email_rounded, 'อีเมล : kruchonlatee@gmail.com'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.auto_awesome_mosaic_outlined, 'สิ่งที่สนใจ : เทคโนโลยี, ธรรมะ, ภาษาและวัฒนธรรม'),
        ],
      ),
    );
  }

  // --- ส่วน BottomAppBar ที่แก้ Overflow แล้ว ---
  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      height: 70,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () => context.go('/home'),
            child: const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.home_filled, color: Colors.grey), Text('หน้าหลัก', style: TextStyle(fontFamily: 'Kanit', fontSize: 10, color: Colors.grey))]),
          ),
          const SizedBox(width: 40),
          // แก้ไข Column ตรงนี้ให้ใช้พื้นที่น้อยลงเพื่อกันพัง
          InkWell(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min, // สำคัญ: ใช้พื้นที่เท่าที่จำเป็น
              children: const [
                Icon(Icons.person, color: brandNavy, size: 24),
                Text('ผู้พัฒนา', 
                  style: TextStyle(fontFamily: 'Kanit', fontSize: 10, color: brandNavy, fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Reusable Widgets (เหมือนเดิม) ---
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: brandNavy, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontFamily: 'Kanit', fontSize: 18, fontWeight: FontWeight.bold, color: brandNavy)),
        ],
      ),
    );
  }

  Widget _buildContentCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F3F5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildTimelineItem(String year, String title, String sub, {required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12, height: 12,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: brandGold, width: 2)),
            ),
            if (!isLast) Container(width: 2, height: 40, color: const Color(0xFFEEEEEE)),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(year, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: brandGold)),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: brandNavy, fontFamily: 'Kanit')),
              Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'Kanit')),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEducationContent() {
    return _buildContentCard([
      _buildTimelineItem('กำลังศึกษา ปริญญาโท คณะวิศวกรรมศาสตร์', 'สาขาวิศวกรรมหุ่นยนต์ฯ', 'สถาบันเทคโนโลยีพระจอมเกล้าเจ้าคุณทหารลาดกระบัง', isLast: false),
      _buildTimelineItem('ESL', 'ESL Program', 'City College of San Francisco', isLast: false),
      _buildTimelineItem('ปริญญาตรี คณะครุศาสตร์อุตสาหกรรม', 'สาขาเทคโนโลยีคอมพิวเตอร์', 'มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ', isLast: false),
      _buildTimelineItem('ปวส.', 'สาขาเทคโนโลยีสารสนเทศ', 'วิทยาลัยเทคนิคท่าหลวงซิเมนต์ไทยอนุสรณ์', isLast: false),
      _buildTimelineItem('ปวช.', 'สาขาช่างอิเล็กทรอนิกส์', 'วิทยาลัยเทคนิคเดชอุดม', isLast: true),
    ]);
  }

  Widget _buildWorkContent() {
    return _buildContentCard([
      _buildTimelineItem('ปัจจุบัน', 'ข้าราชการครู', 'วิทยาลัยเทคนิคชลบุรี', isLast: false),
      _buildTimelineItem('2565', 'Frontend Developer', 'Outsource Team AIS', isLast: false),
      _buildTimelineItem('2564', 'นักประมวลผลข้อมูล ระดับ 4', 'การไฟฟ้านครหลวง', isLast: false),
      _buildTimelineItem('2561', 'ครูอาสาสมัครต่างประเทศ', 'โครงการครุศาสตร์ จุฬาลงกรณ์มหาวิทยาลัย', isLast: false),
      _buildTimelineItem('2559', 'Full-stack Developer', 'Software House', isLast: true),
    ]);
  }

  Widget _buildExpertiseContent() {
    return _buildContentCard([
      const BulletItem('พัฒนาระบบสารสนเทศภาครัฐและเอกชน'),
      const BulletItem('วิทยากรด้านเทคโนโลยีสารสนเทศ'),
    ]);
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: brandGold.withOpacity(0.8)),
        const SizedBox(width: 16),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: brandNavy, fontFamily: 'Kanit'))),
      ],
    );
  }
}

class BulletItem extends StatelessWidget {
  final String text;
  const BulletItem(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Color(0xFFB9976C)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.5, fontFamily: 'Kanit', color: Color(0xFF4A4D50)))),
        ],
      ),
    );
  }
}