import 'dart:io';
import 'package:civic_voice/components/db/db_repo.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/components/models/query_model.dart';
import 'package:civic_voice/components/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DBController extends GetxController {
  final DbRepo _db = DbRepo();
  final storage = FirebaseStorage.instance;

  late UserModel? _user;

  UserModel? get user => _user;

  void storeUser(UserModel user) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    _db.storeIfNeccessary(user.toMap(), "users", uid);
  }

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  Future<void> getUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> mp = await _db.getData("users", uid);
    _user = UserModel.fromMap(mp['data'], uid);
  }

  void updateUser(UserModel user) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await _db.updateUser(user.toMap(), "users", uid);
    getUser();
  }

  void storeComplain(ComplainModel complain) {
    _db.store(complain.toMap(), "complains");
  }

  Future<void> storeQuery(QueryModel query) async {
    await _db.store(query.toMap(), "query");
  }

  Future<List<ComplainModel>> getHistory() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> loadedData = await _db.getHistory('complains', uid);

    if (loadedData['status'] == 'Success') {
      List<ComplainModel> historyList = List<ComplainModel>.from(
        loadedData['data'].map((doc) {
          return ComplainModel.fromMap(doc, doc['id']);
        }),
      );

      return historyList;
    } else {
      return [];
    }
  }

  Future<String?> uploadImage(File image) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    // Create a reference to 'images/mountains.jpg'

    String uid = FirebaseAuth.instance.currentUser!.uid;
    final complainImagesRef =
        storageRef.child("images/${uid}_${DateTime.now()}.jpg");

    try {
      await complainImagesRef.putFile(image);
      String url = await complainImagesRef.getDownloadURL();
      return url;
    } catch (e) {
      Get.snackbar("Error!", e.toString());
    }

    return null;
  }
}
