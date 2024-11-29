import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:civic_voice/components/controller/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthenticationController controller =
      Get.put(AuthenticationController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();

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
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: phoneNumberController,
            cursorColor: Theme.of(context).colorScheme.primary,
            keyboardType: const TextInputType.numberWithOptions(),
            decoration: InputDecoration(
              prefix: Text(
                "+91 ",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              labelText: "Enter your Phone Number",
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
            ),
            style: Theme.of(context).textTheme.labelMedium,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone Number is required';
              } else if (value.length != 10) {
                return 'Phone Number should be of 10 digits';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          PrimaryBlueButton(
            text: "Verify Phone Number",
            textColor: Colors.white,
            bgColor: Theme.of(context).colorScheme.primary,
            onTap: () {
              //SENDS OTP
              if (_formKey.currentState!.validate()) {
                controller
                    .sendOTP("+91${phoneNumberController.text.toLowerCase()}");
              }
            },
          ),
        ],
      ),
    );
  }
}
