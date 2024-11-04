import 'dart:io';

import 'package:camera/camera.dart';
import 'package:civic_voice/components/buttons/primary_blue_button.dart';
import 'package:flutter/material.dart';

class SubmitDetailScreen extends StatelessWidget {
  const SubmitDetailScreen({super.key, required this.image});

  final XFile image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Column(
          children: [
            Image.file(
              File(image.path),
              fit: BoxFit.fill,
              width: double.infinity,
              height: 400,
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              child: Column(
                children: [
                  _textField("Confirm / Edit Address"),
                  const SizedBox(
                    height: 12,
                  ),
                  _textField("Enter Nearby Landmark"),
                  const SizedBox(
                    height: 16,
                  ),
                  PrimaryBlueButton(
                      text: "Next",
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      bgColor: Theme.of(context).colorScheme.primary,
                      onTap: () {})
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _textField(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        TextFormField(
          cursorColor: Colors.black,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.cancel_outlined),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(4),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}
