import 'package:civic_voice/components/controller/authentication_controller.dart';
import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/components/controller/db_controller.dart';
import 'package:civic_voice/components/models/user_model.dart';
import 'package:civic_voice/screens/authentication/otp_verify_screen.dart';
import 'package:civic_voice/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AuthenticationRepo {
  FirebaseAuth auth = FirebaseAuth.instance;

  late String verificationId;
  late String phoneNumber;

  Future<void> sendOTP(String phoneNumber) async {
    final AuthenticationController authenticationController = Get.find();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        authenticationController.isLoading.value = false;
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
          Get.snackbar("Error!", "Invalid Phone Number");
        } else {
          Get.snackbar("Error!", e.code);
        }
        authenticationController.isLoading.value = false;
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        debugPrint("OTP SENT!");
        this.verificationId = verificationId;
        this.phoneNumber = phoneNumber;
        Get.to(() => const OtpVerifyScreen());
        authenticationController.isLoading.value = false;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        authenticationController.isLoading.value = false;
      },
    );
  }

  Future<bool> verifyOTP(String smsCode) async {
    // Create a PhoneAuthCredential with the code
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);

      if (!kIsWeb) {
        final DBController controller = Get.find();
        controller.storeUser(UserModel(phoneNumber: phoneNumber));
      } else {
        final DashboardController dashboardController = Get.find();
        bool isAdmin = await dashboardController.isAdmin(phoneNumber);
        if (!isAdmin) {
          FirebaseAuth.instance.signOut();
          return Future.value(false);
        }
      }

      //Routing based on whether present in dashboard or app
      if (!kIsWeb) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAllNamed('/');
      }

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
