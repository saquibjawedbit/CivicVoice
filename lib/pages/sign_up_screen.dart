import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _logoImage(),
              SizedBox(
                child: Column(
                  children: [
                    _subText(),
                    const SizedBox(
                      height: 32,
                    ),
                    _primaryButton(
                      "Sign Up",
                      Colors.white,
                      Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _secondaryButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell _secondaryButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 17,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromARGB(255, 116, 116, 116),
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Create account",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
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
    );
  }

  Text _subText() {
    return const Text(
      "Sanitation Just\na Tap Away !",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: Color.fromARGB(255, 51, 246, 29),
      ),
    );
  }

  Image _logoImage() {
    return const Image(
      image: AssetImage(
        'assets/images/logo-1.png',
      ),
    );
  }
}
