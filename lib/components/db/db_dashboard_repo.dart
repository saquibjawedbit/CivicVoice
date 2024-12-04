import 'package:cloud_firestore/cloud_firestore.dart';
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
}
