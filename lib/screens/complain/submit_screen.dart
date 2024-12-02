import 'package:camera/camera.dart';
import 'package:civic_voice/components/utils/buttons/primary_blue_button.dart';
import 'package:civic_voice/components/view/image_view.dart';
import 'package:civic_voice/screens/complain/submit_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitScreen extends StatelessWidget {
  const SubmitScreen({super.key, required this.imageFile});

  final XFile imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: _body(),
    );
  }

  Padding _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo-1.png',
              height: 180,
            ),
            ImageView(imageFile: imageFile),
            const SizedBox(
              height: 40,
            ),
            PrimaryBlueButton(
                text: "Confirm Your Image",
                textColor: Colors.white,
                bgColor: Colors.green.shade800,
                onTap: () {
                  Get.to(
                    () => SubmitDetailScreen(image: imageFile),
                    transition: Transition.rightToLeftWithFade,
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            PrimaryBlueButton(
              text: "Retake Image",
              textColor: Colors.white,
              bgColor: Colors.red,
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
