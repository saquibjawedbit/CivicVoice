import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/images/footer.png",
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 36,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/logo-1.png",
                    width: 160,
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          cursorColor: const Color.fromARGB(255, 216, 218, 220),
                          decoration: InputDecoration(
                            labelText: "Enter your Phone Number",
                            border: _inputBorder(),
                            focusedBorder: _inputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 16),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        PrimaryBlueButton(
                          text: "Verify Phone Number",
                          textColor: Colors.white,
                          bgColor: Theme.of(context).colorScheme.primary,
                          onTap: () {
                            //TODO::SENT OTP
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 216, 218, 220),
      ),
    );
  }
}
