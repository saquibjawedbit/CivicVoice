import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logoImage(),
            Image.asset(
              "assets/images/loading.gif",
              fit: BoxFit.fill,
              height: 100,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }

  Image _logoImage() {
    return const Image(
      image: AssetImage(
        'assets/images/logo-1.png',
      ),
      fit: BoxFit.contain,
      width: double.infinity,
    );
  }
}
