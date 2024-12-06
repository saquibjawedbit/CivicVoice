import 'package:civic_voice/components/auth/authentication_repo.dart';
import 'package:civic_voice/components/utils/permission-handler/parmission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepo _auth = AuthenticationRepo();

  @override
  void onInit() {
    if (!kIsWeb) {
      PermissionHandler.requestPermission();
    }
    super.onInit();
  }

  var isLoading = false.obs;

  void sendOTP(String phoneNumber) async {
    isLoading.value = true;
    await _auth.sendOTP(phoneNumber);
  }

  Future<bool> verifyOTP(String code) async {
    bool value = await _auth.verifyOTP(code);
    return value;
  }
}
