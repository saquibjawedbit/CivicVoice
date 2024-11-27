import 'package:civic_voice/screens/authentication/sign_up_screen.dart';
import 'package:civic_voice/screens/profile/history_screen.dart';
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
          seedColor: Colors.blue,
          surface: Colors.white,
          primary: const Color(0xFF002366),
          onPrimary: const Color(0xFF003399),
        ),
        useMaterial3: true,
      ),
      home: HistoryScreen(),
    );
  }
}
