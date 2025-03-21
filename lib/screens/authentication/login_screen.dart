import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:civic_voice/screens/authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/controller/authentication_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthenticationController controller =
      Get.put(AuthenticationController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
              Obx(() {
                if (controller.isLoading.value == true) {
                  return const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }

                return const SizedBox();
              })
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
            controller: emailController,
            cursorColor: Theme.of(context).colorScheme.primary,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email Address",
              contentPadding: EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
            ),
            style: Theme.of(context).textTheme.labelMedium,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              } else if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passwordController,
            cursorColor: Theme.of(context).colorScheme.primary,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
              contentPadding: EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
            ),
            style: Theme.of(context).textTheme.labelMedium,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          PrimaryBlueButton(
            text: "Login",
            textColor: Colors.white,
            bgColor: Theme.of(context).colorScheme.primary,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                await controller.signInWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text,
                );
              }
            },
          ),
          const SizedBox(height: 12),
          TextButton(
            child: const Text("Sign Up"),
            onPressed: () {
              Get.to(() => SignUpScreen());
            },
          ),
        ],
      ),
    );
  }
}
