import 'dart:async';

import 'package:civic_voice/components/controller/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  late int _remainingSeconds;
  Timer? _timer;

  final AuthenticationController _authenticationController = Get.find();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = 30;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  _upMetaData(),
                  const SizedBox(
                    height: 32,
                  ),
                  _otpField(context),
                  const SizedBox(
                    height: 48,
                  ),
                  _timerAndResendButton(context)
                ],
              ),
            ),
            if (_isLoading)
              const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  OtpTextField _otpField(BuildContext context) {
    return OtpTextField(
      clearText: true,
      numberOfFields: 6,
      borderColor: Colors.black,
      enabledBorderColor: Colors.grey,
      focusedBorderColor: Theme.of(context).colorScheme.primary,
      showFieldAsBox: true,
      fieldWidth: 44,
      cursorColor: Theme.of(context).colorScheme.primary,
      autoFocus: true,
      borderRadius: BorderRadius.circular(15),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      //runs when every textfield is filled
      onSubmit: (String verificationCode) async {
        //Submit...
        setState(() {
          _isLoading = true;
        });
        bool value =
            await _authenticationController.verifyOTP(verificationCode);

        if (!value) {
          Get.snackbar("Invalid OTP", "Please enter correct OTP");
        }

        setState(() {
          _isLoading = false;
        });
      }, // end onSubmit
    );
  }

  Text _timerAndResendButton(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Send code again  ',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          TextSpan(
            text: '00:${_remainingSeconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Color.fromARGB(178, 0, 0, 0),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _upMetaData() {
    return SizedBox(
      child: Column(
        children: [
          Image.asset("assets/images/logo-circular.png"),
          const SizedBox(
            height: 15,
          ),
          Text(
            "We've sent an SMS with an activation\ncode to your Phone Number",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ],
      ),
    );
  }
}
