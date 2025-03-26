import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:civic_voice/screens/authentication/forgot_password_screen.dart';
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
                        width: 120,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Welcome Back",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Login to continue",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: emailController,
              cursorColor: Theme.of(context).colorScheme.primary,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email Address",
                prefixIcon: Icon(Icons.email_outlined,
                    color: Theme.of(context).colorScheme.primary),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.labelMedium,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                } else if (!GetUtils.isEmail(value)) {
                  return 'Please enter a valid email';
                } else if (!value.toLowerCase().endsWith('@bitmesra.ac.in')) {
                  return 'Use your college email id';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: passwordController,
              cursorColor: Theme.of(context).colorScheme.primary,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock_outline,
                    color: Theme.of(context).colorScheme.primary),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                border: InputBorder.none,
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
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Navigate to forgot password screen
                Get.to(() => ForgotPasswordScreen());
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextButton(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: () {
                  Get.to(() => SignUpScreen());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
