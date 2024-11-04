import 'package:civic_voice/pages/home_screen.dart';
import 'package:civic_voice/pages/login_screen.dart';
import 'package:civic_voice/pages/otp_verify_screen.dart';
import 'package:civic_voice/pages/sign_up_screen.dart';
import 'package:civic_voice/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Civic Voice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 59, 22, 245),
          primary: const Color.fromARGB(255, 59, 22, 245),
          onPrimary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
