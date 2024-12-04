import 'package:civic_voice/screens/authentication/sign_up_screen.dart';
import 'package:civic_voice/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          debugPrint("Rebuilding");
          if (!snapshot.hasData) {
            return const SignUpScreen();
          }
          return const HomeScreen();
        });
  }
}
