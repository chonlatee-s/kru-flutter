import 'package:flutter/material.dart';
import 'package:kru/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(32, 149, 243, 1)),
        useMaterial3: true,
        fontFamily: 'Kanit',
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
