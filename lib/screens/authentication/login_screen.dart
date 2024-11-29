import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:civic_voice/components/controller/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationController controller =
      Get.put(AuthenticationController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneNumberController = TextEditingController();

  bool _isLoading = false;

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
          child: Stack(
            children: [
              Center(
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
              if (_isLoading)
                const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()),
            ],
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
            onTap: () async {
              //SENDS OTP
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });
                await controller
                    .sendOTP("+91${phoneNumberController.text.toLowerCase()}");
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
