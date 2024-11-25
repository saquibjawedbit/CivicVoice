import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:civic_voice/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo-1.png"),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(31, 0, 0, 0),
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 36, horizontal: 8),
                    child: Column(
                      children: [
                        _blueText(context,
                            "You’re Complaint has been successfully filled !"),
                        const SizedBox(
                          height: 12,
                        ),
                        _blueText(context,
                            "We will notify you as soon as there is any update  !"),
                      ],
                    ),
                  ),
                ],
              ),
              PrimaryBlueButton(
                text: "Home",
                textColor: Colors.white,
                onTap: () => Get.to(
                  () => const HomeScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _blueText(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
