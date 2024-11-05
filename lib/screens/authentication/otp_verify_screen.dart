import 'dart:async';

import 'package:civic_voice/screens/home_screen.dart';
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
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              _upMetaData(),
              const SizedBox(
                height: 32,
              ),
              OtpTextField(
                numberOfFields: 4,
                borderColor: Colors.black,
                enabledBorderColor: Colors.black45,
                focusedBorderColor: Colors.black,
                showFieldAsBox: true,
                fieldWidth: 72,
                cursorColor: Colors.black,
                autoFocus: true,
                borderRadius: BorderRadius.circular(15),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  //TODO::OTP VERTIFCATION
                  Get.offAll(const HomeScreen());
                }, // end onSubmit
              ),
              const SizedBox(
                height: 48,
              ),
              _timerAndResendButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Text _timerAndResendButton(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Send code again  ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
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
          const Text(
            "We've sent an SMS with an activation\ncode to your Phone Number",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(178, 0, 0, 0),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
