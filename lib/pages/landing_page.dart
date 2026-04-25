import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // นิยามสีตามธีมหลัก
  static const Color brandGold = Color(0xFFB9976C);
  static const Color brandNavy = Color(0xFF2D2F31);

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  // ฟังก์ชันหน่วงเวลาเพื่อไปหน้าถัดไป
  void _startLoading() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // ปรับพื้นหลังเป็น Gradient ให้ดูแพงขึ้น
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              brandNavy,
              Color(0xFF1A1C1E), // กรมท่าเข้มเกือบดำ
            ],
          ),
        ),
        child: Stack(
          children: [
            // ส่วนเนื้อหาตรงกลาง
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Hero(
                    tag: 'app-logo',
                    child: Image.asset(
                      'assets/img/logo_new.png',
                      width: 75,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.school, size: 100, color: brandGold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // ชื่อแอป
                  const Text(
                    'ครูผู้ช่วย',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Slogan
                  Text(
                    'ร่วมสร้างสังคมแห่งการแบ่งปัน',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // ส่วน Loading ด้านล่าง
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(brandGold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'กำลังเตรียมความพร้อม...',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
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
}