import 'package:civic_voice/services/auth_service.dart';

class AuthenticationRepo {
  final AuthService _authService = AuthService();

  // Sign up with email and password
  Future<Map<String, dynamic>> signUpWithEmailAndPassword(
      String email, String password,
      {String? name}) async {
    return await _authService.signup(name ?? "User", email, password);
  }

  // Login with email and password
  Future<Map<String, dynamic>> loginWithEmailAndPassword(
      String email, String password) async {
    return await _authService.login(email, password);
  }

  // Get current user data
  Future<Map<String, dynamic>> getCurrentUser() async {
    return await _authService.getMe();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.forgotPassword(email);
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOTP(String otp, {String? token}) async {
    return await _authService.verifyOTP(otp, token: token);
  }

  // Resend OTP
  Future<Map<String, dynamic>> resendOTP({String? token}) async {
    return await _authService.resendOTP(token: token);
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _authService.isAuthenticated();
  }
}
