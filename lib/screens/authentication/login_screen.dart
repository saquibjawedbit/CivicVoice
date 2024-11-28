import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:civic_voice/screens/authentication/otp_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/logo-1.png",
                  width: 320,
                ),
                _form(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _form(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            cursorColor: Theme.of(context).colorScheme.primary,
            keyboardType: const TextInputType.numberWithOptions(),
            decoration: const InputDecoration(
              labelText: "Enter your Phone Number",
              contentPadding: EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
            ),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 12,
          ),
          PrimaryBlueButton(
            text: "Verify Phone Number",
            textColor: Colors.white,
            bgColor: Theme.of(context).colorScheme.primary,
            onTap: () {
              //TODO::SENT OTP
              Get.to(() => const OtpVerifyScreen());
            },
          ),
        ],
      ),
    );
  }
}
