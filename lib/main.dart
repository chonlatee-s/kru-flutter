import 'package:flutter/material.dart';
import 'package:kru/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
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
