import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import '../../components/controller/authentication_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthenticationController controller =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () => Get.back(),
        ),
      ),
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
                        width: 120,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Forgot Password",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Enter your email to receive a password reset link",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _resetForm(context),
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

  Widget _resetForm(BuildContext context) {
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
              controller: _emailController,
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
          const SizedBox(height: 24),
          PrimaryBlueButton(
            text: "Reset Password",
            textColor: Colors.white,
            bgColor: Theme.of(context).colorScheme.primary,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                await controller.resetPassword(
                  email: _emailController.text.trim(),
                );
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Remember your password?",
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextButton(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
