import 'package:civic_voice/components/auth/authentication_repo.dart';
import 'package:civic_voice/components/utils/permission-handler/parmission_handler.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepo _auth = AuthenticationRepo();
  var isLoading = false.obs;

  @override
  void onInit() {
    PermissionHandler.requestPermission();
    super.onInit();
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    await _auth.signUpWithEmailAndPassword(email, password);

    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    await _auth.loginWithEmailAndPassword(email, password);

    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }
}
