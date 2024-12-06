import 'package:civic_voice/components/constants/colors.dart';
import 'package:flutter/material.dart';

final themeData = ThemeData(
  colorScheme: _colorScheme(),
  iconTheme: _iconTheme(),
  textTheme: _textTheme(),
  inputDecorationTheme: _inputTheme(),
  primaryIconTheme: _primaryIconTheme(),
  useMaterial3: true,
);

IconThemeData _primaryIconTheme() {
  return const IconThemeData(
    color: primaryColor,
  );
}

InputDecorationTheme _inputTheme() {
  return InputDecorationTheme(
    labelStyle: const TextStyle(
      color: onPrimaryColor,
    ),
    prefixIconColor: primaryColor,
    hintStyle: TextStyle(
      color: onPrimaryColor.withOpacity(0.6),
    ),
    border: _inputBorder(1.2),
    enabledBorder: _inputBorder(1.2),
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

OutlineInputBorder _inputBorder(double width) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: primaryColor,
      width: width,
    ),
  );
}
