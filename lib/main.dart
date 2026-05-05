import 'package:flutter/material.dart';
import 'package:kru/routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kru/store/app_store.dart'; // 1. เพิ่ม Import นี้

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // เริ่มต้นระบบโฆษณา
  await MobileAds.instance.initialize();
  
  // 2. เพิ่มบรรทัดนี้: เช็คว่ามีข้อมูล User เซฟค้างไว้ในเครื่องไหม
  await checkLoginStatus(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'ครูผู้ช่วย',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 69, 44, 11),
        ),
        useMaterial3: true,
        fontFamily: 'Kanit',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}