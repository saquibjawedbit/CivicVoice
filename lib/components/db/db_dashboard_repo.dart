import 'package:civic_voice/components/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/complain_model.dart';

class DbDashBoardRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ComplainModel>> listenToComplain(LatLngBounds bounds) {
    final res = _db
        .collection('complains')
        .where('latitude', isGreaterThanOrEqualTo: bounds.southWest.latitude)
        .where('latitude', isLessThanOrEqualTo: bounds.northEast.latitude)
        .where('longitude', isGreaterThanOrEqualTo: bounds.southWest.longitude)
        .where('longitude', isLessThanOrEqualTo: bounds.northEast.longitude)
        .where('status', isNotEqualTo: 2)
        .snapshots();

    final finalRes = res.map((data) => data.docs
        .map((value) => ComplainModel.fromMap(value.data(), value.id))
        .toList());

    return finalRes;
  }

  Future<int> getTotalCount(LatLngBounds bounds, int status) async {
    final res = _db
        .collection('complains')
        .where('latitude', isGreaterThanOrEqualTo: bounds.southWest.latitude)
        .where('latitude', isLessThanOrEqualTo: bounds.northEast.latitude)
        .where('longitude', isGreaterThanOrEqualTo: bounds.southWest.longitude)
        .where('longitude', isLessThanOrEqualTo: bounds.northEast.longitude)
        .where('status', isEqualTo: status);

    try {
      // Use aggregate queries to get the count
      AggregateQuerySnapshot snapshot = await res.count().get();
      int count = snapshot.count!;

      return count;
    } catch (e) {
      debugPrint("Error getting document count: $e");
    }

    return 0;
  }

  Future<UserModel> fetchUser(String uid) async {
    final ref = await _db.collection("users").doc(uid).get();
    UserModel user = UserModel.fromMap(ref.data()!, ref.id);
    return user;
  }

  Future<ComplainModel> fetchComplain(String uid) async {
    final ref = await _db.collection("complains").doc(uid).get();
    ComplainModel complain = ComplainModel.fromMap(ref.data()!, ref.id);
    return complain;
  }

  Future<void> updateStatus(int status, String uid) async {
    final data = {
      "status": status,
    };
    await _db.collection("complains").doc(uid).update(data);
  }
}
