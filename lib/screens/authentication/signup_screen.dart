import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/controller/authentication_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthenticationController controller =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
              }),
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
            controller: _emailController,
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
            controller: _passwordController,
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
          const SizedBox(height: 12),
          TextFormField(
            controller: _confirmPasswordController,
            cursorColor: Theme.of(context).colorScheme.primary,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Confirm Password",
              contentPadding: EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
            ),
            style: Theme.of(context).textTheme.labelMedium,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          PrimaryBlueButton(
            text: "Sign Up",
            textColor: Colors.white,
            bgColor: Theme.of(context).colorScheme.primary,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                await controller.signUpWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
                );
              }
            },
          ),
          const SizedBox(height: 12),
          TextButton(
            child: const Text("Already have an account? Login"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
