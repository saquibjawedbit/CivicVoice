import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.imageFile,
  });

  final XFile imageFile;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(imageFile.path),
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      ),
    );
  }
}
