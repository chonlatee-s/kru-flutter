import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../store/app_store.dart';

class TestingPage extends StatefulWidget {
  final String mode;
  TestingPage({super.key, required this.mode});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isFinished = false;
  Timer? _timer;
  int _remainingSeconds = 0;
  
  final Color brandGold = const Color(0xFFB9976C);
  final Color brandNavy = const Color(0xFF2D2F31);
  final Color bgLight = const Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    _remainingSeconds = (widget.mode == 'exam') ? 20 * 60 : 10 * 60;
    _startTimer();
    _checkData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        _finishExam();
      }
    });
  }

  void _checkData() {
    if (testings.isNotEmpty) {
      setState(() => _isLoading = false);
    } else {
      testingsChanged.addListener(_onDataLoaded);
    }
  }

  void _onDataLoaded() {
    if (mounted && testings.isNotEmpty) {
      setState(() => _isLoading = false);
      testingsChanged.removeListener(_onDataLoaded);
    }
  }

  void _finishExam() {
    _timer?.cancel();
    int score = 0;
    int limit = (widget.mode == 'exam') ? 20 : 10;
    if (testings.length < limit) limit = testings.length;

    for (int i = 0; i < limit; i++) {
      if (testings[i]['answer_user'].toString() == testings[i]['correct_answer_index'].toString()) {
        score++;
      }
    }

    if (widget.mode == 'exam' && currentUser != null) {
      _saveScore(score, limit);
    }

    setState(() => _isFinished = true);
    _showResultDialog(score, limit);
  }

  void _showResultDialog(int score, int limit) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('สรุปผลการสอบ', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
        content: Text('คุณทำได้ $score / $limit คะแนน', textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Kanit', fontSize: 20)),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: brandNavy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('ดูเฉลยละเอียด', style: TextStyle(color: Colors.white, fontFamily: 'Kanit')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveScore(int score, int total) async {
    try {
      int initialSeconds = (widget.mode == 'exam') ? 20 * 60 : 10 * 60;
      int durationUsed = initialSeconds - _remainingSeconds;
      await http.post(
        Uri.parse('$baseUrl/api_save_score.php'),
        headers: apiHeaders,
        body: jsonEncode({
          'email': currentUser!['email'],
          'subject': 'แบบทดสอบครูผู้ช่วย',
          'score': score,
          'total': total,
          'duration': durationUsed,
        }),
      );
    } catch (e) { debugPrint('Save Error: $e'); }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Scaffold(backgroundColor: brandNavy, body: const Center(child: CircularProgressIndicator(color: Colors.white)));
    if (_isFinished) return _buildReviewView();

    int limit = (widget.mode == 'exam') ? 20 : 10;
    if (testings.length < limit) limit = testings.length;
    final q = testings[_currentIndex];
    double progress = (_currentIndex + 1) / limit;

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.pop(context)),
        title: const Text('แบบทดสอบครูผู้ช่วย', style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: brandNavy, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(Icons.timer, color: Colors.white, size: 16),
                const SizedBox(width: 5),
                Text('${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}', 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          )
        ],
        backgroundColor: Colors.white,
        foregroundColor: brandNavy,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ส่วน Progress Bar ตามรูป 2
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ความก้าวหน้า (ตอบแล้ว ${_currentIndex + 1}/$limit ข้อ)', style: TextStyle(fontFamily: 'Kanit', fontSize: 12, color: Colors.grey[600])),
                Text('${(progress * 100).toInt()}%', style: TextStyle(fontFamily: 'Kanit', fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: brandGold.withOpacity(0.1), color: brandGold),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // การ์ดโจทย์ (ตามรูป 2)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ข้อที่ ${_currentIndex + 1}', style: TextStyle(fontFamily: 'Kanit', color: brandGold, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(q['question'] ?? '', style: TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.bold, color: brandNavy, height: 1.5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ตัวเลือก (ตามรูป 2)
                  ...(q['options'] as List).asMap().entries.map((entry) {
                    int idx = entry.key + 1;
                    String label = String.fromCharCode(64 + idx); // A, B, C, D
                    bool isSelected = q['answer_user'].toString() == idx.toString();
                    return _buildOption(idx, label, entry.value['text'], isSelected, limit);
                  }).toList(),
                ],
              ),
            ),
          ),
          _buildBottomNav(limit),
        ],
      ),
    );
  }

  Widget _buildOption(int idx, String label, String text, bool isSelected, int limit) {
    return GestureDetector(
      onTap: () {
        setState(() => testings[_currentIndex]['answer_user'] = idx.toString());
        if (_currentIndex < limit - 1) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) setState(() => _currentIndex++);
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? brandGold : Colors.grey.shade200, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: isSelected ? brandGold : bgLight, borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[600], fontWeight: FontWeight.bold))),
            ),
            const SizedBox(width: 15),
            Expanded(child: Text(text, style: TextStyle(fontFamily: 'Kanit', color: brandNavy, fontSize: 15))),
            if (isSelected) Icon(Icons.check_circle, color: brandGold, size: 20),
          ],
        ),
      ),
    );
  }

Widget _buildBottomNav(int limit) {
    // ใช้ SafeArea เพื่อป้องกันปุ่มจมหรือลอยเกินไปในมือถือทุกรุ่น
    return SafeArea(
      top: false, // เอาแค่ด้านล่าง
      child: Container(
        // ลดระยะ Padding ด้านบนและล่างลง (จากเดิม 15/30 เหลือ 10/10)
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          // เพิ่มเส้นขอบด้านบนบางๆ เพื่อให้ดูแยกส่วนกับเนื้อหาชัดเจน
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ปุ่มย้อนกลับ
            _currentIndex > 0 
              ? OutlinedButton.icon(
                  onPressed: () => setState(() => _currentIndex--),
                  icon: const Icon(Icons.arrow_back, size: 18), 
                  label: const Text('ย้อนกลับ', style: TextStyle(fontFamily: 'Kanit')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700], 
                    side: BorderSide(color: Colors.grey.shade300), 
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                )
              : const SizedBox(width: 40), // รักษาพื้นที่ไว้
            
            // ปุ่มข้อถัดไป / ส่งข้อสอบ
            ElevatedButton.icon(
              onPressed: () => _currentIndex == limit - 1 ? _finishExam() : setState(() => _currentIndex++),
              icon: Icon(_currentIndex == limit - 1 ? Icons.send : Icons.arrow_forward, size: 18),
              label: Text(
                _currentIndex == limit - 1 ? 'ส่งข้อสอบ' : 'ข้อถัดไป', 
                style: const TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: brandNavy, 
                foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), 
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ส่วนหน้าเฉลย (ตามรูป 1) ---
  Widget _buildReviewView() {
    int limit = (widget.mode == 'exam') ? 20 : 10;
    if (testings.length < limit) limit = testings.length;
    
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: const Text('เฉลยละเอียด', style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, foregroundColor: brandNavy, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: limit,
        itemBuilder: (context, index) {
          final q = testings[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade100)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // เลขข้อ (รูป 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: brandGold.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Text('ข้อที่ ${index + 1}', style: TextStyle(fontFamily: 'Kanit', color: brandGold, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(height: 12),
                Text(q['question'] ?? '', style: const TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.bold, height: 1.5)),
                const SizedBox(height: 20),
                // ตัวเลือกเฉลย (รูป 1)
                ...(q['options'] as List).asMap().entries.map((entry) {
                  int optIdx = entry.key + 1;
                  String label = String.fromCharCode(64 + optIdx);
                  bool isCorrect = q['correct_answer_index'].toString() == optIdx.toString();
                  bool isUser = q['answer_user'].toString() == optIdx.toString();
                  
                  Color borderColor = Colors.grey.shade100;
                  Color bgColor = Colors.white;
                  Widget? icon;

                  if (isCorrect) {
                    borderColor = Colors.green.shade400;
                    bgColor = Colors.green.shade50;
                    icon = const Icon(Icons.check_circle, color: Colors.green, size: 20);
                  } else if (isUser && !isCorrect) {
                    borderColor = Colors.red.shade400;
                    bgColor = Colors.red.shade50;
                    icon = const Icon(Icons.cancel, color: Colors.red, size: 20);
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: borderColor)),
                    child: Row(
                      children: [
                        Container(width: 28, height: 28, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)), child: Center(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
                        const SizedBox(width: 12),
                        Expanded(child: Text(entry.value['text'], style: TextStyle(fontFamily: 'Kanit', fontSize: 14, color: isUser || isCorrect ? brandNavy : Colors.grey))),
                        if (icon != null) icon,
                      ],
                    ),
                  );
                }).toList(),
                // กล่องคำอธิบาย (รูป 1)
                if (q['explanation'] != null && q['explanation'] != "")
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F6F2),
                      borderRadius: BorderRadius.circular(15),
                      border: const Border(left: BorderSide(color: Color(0xFFB9976C), width: 4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.menu_book, size: 18, color: brandGold),
                            const SizedBox(width: 8),
                            Text('คำอธิบายเฉลย', style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold, color: brandGold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(q['explanation'], style: TextStyle(fontFamily: 'Kanit', fontSize: 13, color: brandNavy.withOpacity(0.8), height: 1.5)),
                        if (q['detail_url'] != null && q['detail_url'] != "")
                          TextButton(
                            onPressed: () => launchUrl(Uri.parse(q['detail_url'])),
                            child: const Text('อ่านรายละเอียดเพิ่มเติม ➔', style: TextStyle(fontFamily: 'Kanit', fontSize: 12, decoration: TextDecoration.underline)),
                          )
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}