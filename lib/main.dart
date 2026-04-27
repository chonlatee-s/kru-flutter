import 'package:flutter/material.dart';
import 'package:kru/routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
