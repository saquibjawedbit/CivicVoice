import 'package:civic_voice/components/controller/db_controller.dart';
import 'package:civic_voice/components/models/user_model.dart';
import 'package:civic_voice/screens/authentication/otp_verify_screen.dart';
import 'package:civic_voice/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationRepo {
  FirebaseAuth auth = FirebaseAuth.instance;

  late String verificationId;
  late String phoneNumber;

  void sendOTP(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
          Get.snackbar("Error!", "Invalid Phone Number");
        } else {
          Get.snackbar("Error!", e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        debugPrint("OTP SENT!");
        this.verificationId = verificationId;
        this.phoneNumber = phoneNumber;
        Get.to(() => const OtpVerifyScreen());
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP(String smsCode) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await auth.signInWithCredential(credential);

    final DBController controller = Get.find();
    controller.storeUser(UserModel(phoneNumber: phoneNumber));

    Get.offAll(() => const HomeScreen());
  }
}
