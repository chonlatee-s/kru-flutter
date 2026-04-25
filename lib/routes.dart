import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kru/pages/about_us_page.dart';
import 'package:kru/pages/exam_history_page.dart';
import 'package:kru/pages/home_page.dart';
import 'package:kru/pages/job_page.dart';
import 'package:kru/pages/landing_page.dart';
import 'package:kru/pages/pay_page.dart';
import 'package:kru/pages/predict_page.dart';
import 'package:kru/pages/exam_mode_page.dart';
import 'package:kru/pages/testing_page.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) => const LandingPage(),
  ),
  GoRoute(
    path: '/home',
    builder: (BuildContext context, GoRouterState state) => const HomePage(),
  ),
  GoRoute(
    path: '/aboutUs',
    builder: (BuildContext context, GoRouterState state) => const AboutUsPage(),
  ),
  GoRoute(
    path: '/predict',
    builder: (BuildContext context, GoRouterState state) => const PredictPage(),
  ),
  GoRoute(
    path: '/pay',
    builder: (BuildContext context, GoRouterState state) => const PayPage(),
  ),
  // --- จุดที่แก้ไข: รับ Mode จากหน้าเลือกโหมด ---
  GoRoute(
    path: '/testing',
    builder: (BuildContext context, GoRouterState state) {
      // ดึงค่าจาก ?mode=... ที่ส่งมาใน URL
      final String? modeFromQuery = state.uri.queryParameters['mode'];
      
      print("DEBUG: Router ได้รับค่าจาก URL = $modeFromQuery");
      
      return TestingPage(mode: modeFromQuery ?? 'practice');
    },
  ),
  // ---------------------------------------
  GoRoute(
    path: '/job',
    builder: (BuildContext context, GoRouterState state) => const JobPage(),
  ),
  GoRoute(
    path: '/exam-mode', 
    builder: (BuildContext context, GoRouterState state) => const ExamModePage(),
  ),
  GoRoute(
    path: '/history', 
    builder: (BuildContext context, GoRouterState state) => const ExamHistoryPage(),
  ),
]);