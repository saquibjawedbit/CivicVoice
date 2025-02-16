import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String allowedDomain = 'bitmesra.ac.in';

  bool _isAllowedDomain(String email) {
    return email.toLowerCase().endsWith('@$allowedDomain');
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    if (!_isAllowedDomain(email)) {
      throw FirebaseAuthException(
        code: 'invalid-domain',
        message: 'Only @bitmesra.ac.in email addresses are allowed',
      );
    }

    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error signing in with email: $e');
      rethrow;
    }
  }

  Future<UserCredential?> registerWithEmail(
      String email, String password) async {
    if (!_isAllowedDomain(email)) {
      throw FirebaseAuthException(
        code: 'invalid-domain',
        message: 'Only @bitmesra.ac.in email addresses are allowed',
      );
    }

    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error registering with email: $e');
      rethrow;
    }
  }
}
