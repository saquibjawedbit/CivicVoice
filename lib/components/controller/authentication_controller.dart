import 'package:civic_voice/components/auth/authentication_repo.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepo _auth = AuthenticationRepo();

  void sendOTP(String phoneNumber) {
    _auth.sendOTP(phoneNumber);
  }

  void verifyOTP(String code) {
    _auth.verifyOTP(code);
  }
}
