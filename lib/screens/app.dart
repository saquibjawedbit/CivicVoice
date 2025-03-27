import 'package:civic_voice/screens/authentication/landing_screen.dart';
import 'package:civic_voice/screens/home_screen.dart';
import 'package:civic_voice/services/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:civic_voice/components/controller/authentication_controller.dart';

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _initializeControllers();
    _checkAuthStatus();
  }

  void _initializeControllers() {
    // Make sure the AuthenticationController is available throughout the app
    if (!Get.isRegistered<AuthenticationController>()) {
      Get.put(AuthenticationController());
    }
  }

  Future<void> _checkAuthStatus() async {
    // Check if a valid token exists
    final hasToken = await TokenStorage.hasValidToken();

    setState(() {
      _isAuthenticated = hasToken;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show loading indicator while checking auth status
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Navigate to home screen if authenticated, landing screen if not
    return _isAuthenticated ? const HomeScreen() : const LandingScreen();
  }
}
