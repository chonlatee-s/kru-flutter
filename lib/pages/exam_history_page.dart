import 'package:flutter/material.dart';
import '../store/app_store.dart';

class ExamHistoryPage extends StatefulWidget {
  const ExamHistoryPage({super.key});

  @override
  State<ExamHistoryPage> createState() => _ExamHistoryPageState();
}

class _ExamHistoryPageState extends State<ExamHistoryPage> {
  static const Color brandGold = Color(0xFFB9976C);
  static const Color brandNavy = Color(0xFF2D2F31);

  @override
  void initState() {
    super.initState();
    getExamHistory();
    examHistoryChanged.addListener(_updateData);
  }

  @override
  void dispose() {
    examHistoryChanged.removeListener(_updateData);
    super.dispose();
  }

  void _updateData() => setState(() {});

  // --- ฟังก์ชันแปลงวันที่เป็นภาษาไทย ---
  String _formatThaiDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      DateTime dt = DateTime.parse(dateStr);
      List<String> months = [
        'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
        'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
      ];
      // แปลงปี ค.ศ. เป็น พ.ศ. (+543)
      int thaiYear = dt.year + 543;
      return '${dt.day} ${months[dt.month - 1]} $thaiYear | ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} น.';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(dynamic seconds) {
    int sec = int.tryParse(seconds.toString()) ?? 0;
    if (sec < 60) return '$sec วินาที';
    int m = sec ~/ 60;
    int s = sec % 60;
    return '$m นาที $s วินาที';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('ประวัติการทำข้อสอบ', 
          style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold, color: brandNavy)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: brandNavy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: examHistory.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                _buildHeaderSummary(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: examHistory.length,
                    itemBuilder: (context, index) {
                      final item = examHistory[index];
                      return _buildHistoryCard(item);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: brandNavy,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: brandNavy.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('ฝึกฝนไปแล้ว', '${examHistory.length} ครั้ง', Icons.auto_graph),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildSummaryItem('คะแนนล่าสุด', '${examHistory[0]['score']}/${examHistory[0]['total_questions']}', Icons.stars),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: brandGold, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Kanit')),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Kanit')),
      ],
    );
  }

  Widget _buildHistoryCard(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(item['subject_name'] ?? 'สอบคลังข้อสอบ', 
                      //   style: const TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.bold, color: brandNavy)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.event_note, size: 14, color: brandGold),
                          const SizedBox(width: 6),
                          Text(_formatThaiDate(item['created_at']), 
                            style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontFamily: 'Kanit')),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: brandGold),
                          const SizedBox(width: 6),
                          Text('ใช้เวลา: ${_formatTime(item['time_spent'])}', 
                            style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontFamily: 'Kanit')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // วงกลมคะแนน
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${item['score']}', 
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: brandGold, fontFamily: 'Kanit')),
                    Text('คะแนน', style: TextStyle(fontSize: 10, color: brandNavy.withOpacity(0.5), fontFamily: 'Kanit')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_edu, size: 100, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          const Text('ไม่พบประวัติการทำข้อสอบ', 
            style: TextStyle(fontFamily: 'Kanit', color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}