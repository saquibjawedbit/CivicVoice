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
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Theme.of(context).colorScheme.primary,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          labelText: "Enter your Phone Number",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          border: _inputBorder(context, 1.2),
                          focusedBorder: _inputBorder(context, 1.6),
                          enabledBorder: _inputBorder(context, 1.2),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder(context, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: width,
      ),
    );
  }
}
