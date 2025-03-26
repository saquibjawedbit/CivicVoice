import 'package:civic_voice/components/auth/authentication_repo.dart';
import 'package:civic_voice/components/utils/permission-handler/parmission_handler.dart';
import 'package:civic_voice/screens/authentication/login_screen.dart';
import 'package:civic_voice/screens/authentication/otp_verification_screen.dart';
import 'package:civic_voice/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepo _auth = AuthenticationRepo();
  var isLoading = false.obs;
  var user = Rxn<Map<String, dynamic>>();

  // Store temporary data during signup process
  final _tempEmail = ''.obs;
  final _tempPassword = ''.obs;

  @override
  void onInit() {
    PermissionHandler.requestPermission();
    checkAuthStatus();
    super.onInit();
  }

  // Check if the user is already authenticated
  Future<void> checkAuthStatus() async {
    try {
      isLoading.value = true;
      final isAuth = await _auth.isAuthenticated();

      if (isAuth) {
        // Fetch current user data
        await getUserData();
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get current user data
  Future<void> getUserData() async {
    try {
      isLoading.value = true;
      final userData = await _auth.getCurrentUser();
      user.value = userData;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch user data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // Store email and password temporarily
      _tempEmail.value = email;
      _tempPassword.value = password;

      // Call the API to create account and trigger OTP sending
      await _auth.signUpWithEmailAndPassword(email, password);

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

  // Resend OTP via API
  Future<void> resendOTP() async {
    try {
      isLoading.value = true;
      await _auth.resendOTP();

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

  // Verify OTP via API
  Future<void> verifyOTP({
    required String otp,
  }) async {
    try {
      isLoading.value = true;
      await _auth.verifyOTP(otp);

      Get.snackbar(
        'Success',
        'Account verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Fetch user data after successful verification
      await getUserData();

      // Redirect to home page
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

  // Login with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await _auth.loginWithEmailAndPassword(email, password);

      // Fetch user data after successful login
      await getUserData();

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

  // Reset password (forgot password)
  Future<void> resetPassword({required String email}) async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email);

      // Show a responsive alert dialog
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // Making the dialog responsive with constraints
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: LayoutBuilder(builder: (context, constraints) {
            // Adjust to the screen size
            double maxWidth = constraints.maxWidth;
            double dialogWidth = maxWidth > 450 ? 450 : maxWidth;

            return Container(
              width: dialogWidth,
              constraints: const BoxConstraints(
                maxWidth: 450,
                // Adjust height based on content
                minHeight: 100,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green, size: maxWidth < 300 ? 20 : 28),
                      SizedBox(width: maxWidth < 300 ? 6 : 10),
                      Flexible(
                        child: Text(
                          'Password Reset Email Sent',
                          style: TextStyle(
                            fontSize: maxWidth < 300 ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Body content
                  Text(
                    'We have sent a password reset link to:',
                    style: TextStyle(fontSize: maxWidth < 300 ? 14 : 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      email,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: maxWidth < 300 ? 14 : 16,
                        color: Get.theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Please check your email and follow the instructions to reset your password.',
                    style: TextStyle(fontSize: maxWidth < 300 ? 14 : 16),
                  ),
                  const SizedBox(height: 24),
                  // Action button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: maxWidth < 300 ? 16 : 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: maxWidth < 300 ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Get.back(); // Close dialog
                        Get.back(); // Return to login screen
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        barrierDismissible: false,
      );
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

  // Logout and clear user data
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _auth.logout();
      user.value = null;

      // Return to login screen
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
