import 'package:civic_voice/components/controller/authentication_controller.dart';
import 'package:civic_voice/components/controller/db_controller.dart';
import 'package:civic_voice/components/models/user_model.dart';
import 'package:civic_voice/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationRepo {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    final AuthenticationController authenticationController = Get.find();
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final DBController controller = Get.find();
      controller.storeUser(UserModel(email: email));

      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error!", e.code);
    } finally {
      authenticationController.isLoading.value = false;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    final AuthenticationController authenticationController = Get.find();
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error!", e.code);
    } finally {
      authenticationController.isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
