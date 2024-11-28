import 'package:civic_voice/components/constants/colors.dart';
import 'package:civic_voice/screens/authentication/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          primary: primaryColor,
          onPrimary: onPrimaryColor,
        ),
        iconTheme: const IconThemeData(
          color: primaryColor, // Set the default icon color to primary
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: primaryColor,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          displayMedium: TextStyle(
            color: onPrimaryColor,
            fontSize: 18,
          ),
          labelMedium: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          labelSmall: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: primaryColor,
            fontSize: 72,
            fontWeight: FontWeight.bold,
            height: 0.8,
          ),
          titleSmall: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(
            color: onPrimaryColor,
          ),
          prefixIconColor: primaryColor,
          hintStyle: TextStyle(
            color: onPrimaryColor.withOpacity(0.6),
          ),
          border: _inputBorder(context, 1.2),
          enabledBorder: _inputBorder(context, 1.2),
        ),
        primaryIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        useMaterial3: true,
      ),
      home: const SignUpScreen(),
    );
  }

  OutlineInputBorder _inputBorder(context, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: primaryColor,
        width: width,
      ),
    );
  }
}
