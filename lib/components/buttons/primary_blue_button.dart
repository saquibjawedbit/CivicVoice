import 'package:flutter/material.dart';

class PrimaryBlueButton extends StatelessWidget {
  const PrimaryBlueButton(
      {super.key,
      required this.text,
      required this.textColor,
      required this.bgColor,
      required this.onTap});

  final String text;
  final Color textColor;
  final Color bgColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 17),
        minimumSize: const Size(double.infinity, 10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
