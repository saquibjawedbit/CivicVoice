import 'package:civic_voice/components/db/db_repo.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/components/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DBController extends GetxController {
  final DbRepo _db = DbRepo();

  void storeUser(UserModel user) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    _db.storeIfNeccessary(user.toMap(), "users", uid);
  }

  void storeComplain(ComplainModel complain) {
    _db.store(complain.toMap(), "complains");
  }
}
