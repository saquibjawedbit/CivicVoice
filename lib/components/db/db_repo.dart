import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DbRepo {
  final db = FirebaseFirestore.instance;

  Future<void> store(Map<String, dynamic> data, String collection,
      {String? uid}) async {
    if (uid != null) {
      await db.collection(collection).doc(uid).set(data);
    } else {
      await db.collection(collection).doc().set(data);
    }
  }

  Future<void> updateUser(
      Map<String, dynamic> data, String collection, String uid) async {
    await db.collection(collection).doc(uid).set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>> getData(String collection, String uid) async {
    final docRef = db.collection(collection).doc(uid);
    final docSnapshot = await docRef.get();
    return {
      "id": docSnapshot.id,
      "data": docSnapshot.data(),
    };
  }

  void storeIfNeccessary(
    Map<String, dynamic> data,
    String collections,
    String uid,
  ) async {
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

  Future<Map<String, dynamic>> getHistory(
      String collection, String userId) async {
    try {
      // Fetching the complaints from Firestore based on userId
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .orderBy('complaintDate',
              descending: true) // Assuming you want to order by the date
          .get();

      // If no documents found, return an empty map
      if (snapshot.docs.isEmpty) {
        return {'status': 'No history found', 'data': []};
      }

      // Extracting the data from the documents
      List<Map<String, dynamic>> historyList = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      // Returning the history
      return {'status': 'Success', 'data': historyList};
    } catch (e) {
      debugPrint("Error fetching history: $e");
      return {'status': 'Error', 'data': []};
    }
  }
}
