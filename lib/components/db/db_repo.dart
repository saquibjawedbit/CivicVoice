import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DbRepo {
  final db = FirebaseFirestore.instance;

  void store(Map<String, dynamic> data, String collection,
      {String? uid}) async {
    await db.collection(collection).doc(uid).set(data);
  }

  void storeIfNeccessary(
      Map<String, dynamic> data, String uid, String collections) async {
    final docRef = db.collection(collections).doc(uid);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      debugPrint("User Exists Logging In!");
      return;
    } else {
      debugPrint("New User!");
      store(data, collections, uid: uid);
    }
  }
}
