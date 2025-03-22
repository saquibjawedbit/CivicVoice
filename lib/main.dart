import 'package:civic_voice/components/constants/colors.dart';
import 'package:civic_voice/screens/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Civic Voice',
      theme: _theme(context),
      home: Builder(builder: (context) {
        return const App();
      }),
    );
  }

  ThemeData _theme(BuildContext context) {
    return ThemeData(
      colorScheme: _colorScheme(),
      iconTheme: _iconTheme(),
      textTheme: _textTheme(),
      inputDecorationTheme: _inputTheme(context),
      primaryIconTheme: _primaryIconTheme(context),
      useMaterial3: true,
    );
  }

  IconThemeData _primaryIconTheme(BuildContext context) {
    return IconThemeData(
      color: Theme.of(context).colorScheme.primary,
    );
  }

  InputDecorationTheme _inputTheme(BuildContext context) {
    return InputDecorationTheme(
      labelStyle: const TextStyle(
        color: onPrimaryColor,
      ),
      prefixIconColor: primaryColor,
      hintStyle: TextStyle(
        color: onPrimaryColor.withOpacity(0.6),
      ),
      border: _inputBorder(context, 1.2),
      enabledBorder: _inputBorder(context, 1.2),
    );
  }

  TextTheme _textTheme() {
    return const TextTheme(
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
    );
  }

  IconThemeData _iconTheme() {
    return const IconThemeData(
      color: primaryColor, // Set the default icon color to primary
    );
  }

  ColorScheme _colorScheme() {
    return ColorScheme.fromSeed(
      seedColor: Colors.blue,
      surface: Colors.white,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
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
