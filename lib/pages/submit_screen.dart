import 'dart:io';

import 'package:camera/camera.dart';
import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:civic_voice/pages/submit_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitScreen extends StatelessWidget {
  const SubmitScreen({super.key, required this.imageFile});

  final XFile imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo-1.png',
                height: 180,
              ),
              Expanded(
                child: Image.file(
                  File(imageFile.path),
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              _decButtons(
                  context, "assets/images/ahead.png", "Comfirm your Image", () {
                Get.to(() => SubmitDetailScreen(image: imageFile));
              }),
              const SizedBox(
                height: 20,
              ),
              _decButtons(context, "assets/images/cross.png", "Retake Image",
                  () {
                Get.back();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _decButtons(
      BuildContext context, String imagePath, String text, Function() onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 200,
          child: PrimaryBlueButton(
            text: text,
            textColor: Colors.white,
            bgColor: Theme.of(context).colorScheme.primary,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
