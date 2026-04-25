import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kru/store/app_store.dart';

class PredictPage extends StatefulWidget {
  const PredictPage({super.key});

  @override
  State<PredictPage> createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> with SingleTickerProviderStateMixin {
  bool isLoading = true;
  late AnimationController _controller;

  static const Color brandGold = Color(0xFFB9976C);
  static const Color brandNavy = Color(0xFF2D2F31);

  @override
  void initState() {
    super.initState();
    // สร้าง Animation สำหรับการ "เขย่า"
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..repeat(reverse: true);
    
    loadPredict();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: brandNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'เซียมซีเสี่ยงทาย',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: brandNavy,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) _buildShakingCup() else _buildPredictResult(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget ขณะกำลังเขย่า ---
  Widget _buildShakingCup() {
    return Column(
      children: [
        // อนิเมชั่นรูปกระบอกเซียมซี (ถ้าไม่มีรูป ใช้ Icon แทน)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 0.1, // เขย่าเบาๆ
              child: child,
            );
          },
          child: const Icon(
            Icons.vibration, // หรือเปลี่ยนเป็นรูปกระบอกเซียมซีของคุณครู
            size: 100,
            color: brandGold,
          ),
        ),
        const SizedBox(height: 30),
        const CircularProgressIndicator(color: brandGold),
        const SizedBox(height: 20),
        const Text(
          'ตั้งจิตอธิษฐาน...',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: brandNavy,
          ),
        ),
      ],
    );
  }

  // --- Widget ผลลัพธ์ ---
  Widget _buildPredictResult() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          // ใบเซียมซี
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: brandGold.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'ผลทำนายเซียมซี',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 16,
                    color: brandGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 30, color: brandGold),
                
                ListenableBuilder(
                  listenable: predictNumberChanged,
                  builder: (context, child) {
                    return Text(
                      'เลขที่ $predictNumber',
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: brandNavy,
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 20),
                
                ListenableBuilder(
                  listenable: predictResultChanged,
                  builder: (context, child) {
                    return Text(
                      predictResult,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 30),
                const Text(
                  'ที่มา: วัดพระธาตุหนองบัว จ.อุบลราชธานี',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // ปุ่มลองอีกครั้ง
          ElevatedButton.icon(
            onPressed: loadPredict,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('เสี่ยงทายอีกครั้ง', style: TextStyle(fontFamily: 'Kanit', fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandNavy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 5,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  void loadPredict() {
    setState(() {
      isLoading = true;
    });
    
    // เรียก API ดึงผลทำนาย
    getPredict();

    // หน่วงเวลาเพื่อความตื่นเต้น
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }
}