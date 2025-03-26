import 'package:civic_voice/components/auth/authentication_repo.dart';
import 'package:civic_voice/components/utils/permission-handler/parmission_handler.dart';
import 'package:civic_voice/screens/home_screen.dart';
import 'package:civic_voice/screens/authentication/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepo _auth = AuthenticationRepo();
  var isLoading = false.obs;

  // Store temporary data during signup process
  final _tempEmail = ''.obs;
  final _tempPassword = ''.obs;

  @override
  void onInit() {
    PermissionHandler.requestPermission();
    super.onInit();
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // Store email and password temporarily
      _tempEmail.value = email;
      _tempPassword.value = password;

      // Generate and send OTP
      await _sendOTP(email);

      // Navigate to OTP verification screen
      Get.to(() => OtpVerificationScreen(
            email: email,
            password: password,
          ));
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _sendOTP(String email) async {
    // Here we would actually send an OTP via email
    // For now, we'll simulate it with a delay
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('OTP sent to $email');

    // In a real implementation, this would call your backend API to send an OTP
    // await _auth.sendOTP(email);
  }

  Future<void> resendOTP({required String email}) async {
    try {
      isLoading.value = true;
      await _sendOTP(email);
      Get.snackbar(
        'OTP Resent',
        'A new verification code has been sent to your email',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend OTP: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP({
    required String email,
    required String password,
    required String otp,
  }) async {
    try {
      isLoading.value = true;

      // Here we would actually verify the OTP with our backend
      // For now, let's assume 123456 is the correct OTP
      if (otp == '123456') {
        // Register the user after successful verification
        await _auth.signUpWithEmailAndPassword(email, password);

        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Redirect to home page
        Get.offAll(() => const HomeScreen());
      } else {
        throw Exception('Invalid OTP. Please try again.');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await _auth.loginWithEmailAndPassword(email, password);
      await Future.delayed(const Duration(seconds: 1));

      // Redirect to home page after successful login
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      isLoading.value = true;

      // In a real implementation, this would call your backend API to send a reset link
      // await _auth.sendPasswordResetEmail(email);

      // For now, simulate with a delay
      await Future.delayed(const Duration(seconds: 2));
      debugPrint('Password reset email sent to $email');

      Get.snackbar(
        'Password Reset',
        'Check your email for a password reset link',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Return to login screen
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send password reset email: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
