import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_page.dart';
import 'screens/register_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // ← INI HARUS SPLASH SCREEN SEBAGAI AWAL
    );
  }
}
