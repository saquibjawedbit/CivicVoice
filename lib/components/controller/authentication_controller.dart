import 'package:civic_voice/components/auth/authentication_repo.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepo _auth = AuthenticationRepo();

  Future<void> sendOTP(String phoneNumber) async {
    await _auth.sendOTP(phoneNumber);
  }

  Future<void> verifyOTP(String code) async {
    await _auth.verifyOTP(code);
  }
}
