import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:civic_voice/screens/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CIVIC VOICE",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        height: 0.8,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "   Report it, Resolve it",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    _subText(context),
                    const SizedBox(
                      height: 18,
                    ),
                    _primaryButton(
                      "Join Us",
                      Colors.white,
                      Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PrimaryBlueButton _primaryButton(
      String text, Color textColor, Color bgColor) {
    return PrimaryBlueButton(
      text: text,
      textColor: textColor,
      bgColor: bgColor,
      onTap: () {
        Get.to(() => const LoginScreen());
      },
    );
  }

  Widget _subText(context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.primary,
          ),
          children: const [
            TextSpan(
              text: 'Your Voice\n',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            TextSpan(
              text: 'Our Action',
              style: TextStyle(
                fontSize: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
