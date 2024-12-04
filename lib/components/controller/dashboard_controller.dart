import 'dart:async';

import 'package:civic_voice/components/db/db_dashboard_repo.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:civic_voice/components/models/user_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final DbDashBoardRepo _dbDashBoardRepo = DbDashBoardRepo();

  var data = <ComplainModel>[].obs;
  StreamSubscription<List<ComplainModel>>? _subs;
  var resolved = 0.0.obs;
  var pending = 0.0.obs;
  var working = 0.0.obs;

  void listenComplainData(LatLngBounds bounds) {
    _subs?.cancel();
    final nData = _dbDashBoardRepo.listenToComplain(bounds);
    getCount(bounds);
    _subs = nData.listen((newData) {
      data.value = newData;
    });
  }

  void getCount(LatLngBounds bounds) async {
    final pending = await _dbDashBoardRepo.getTotalCount(bounds, 0);
    final working = await _dbDashBoardRepo.getTotalCount(bounds, 1);
    final accepted = await _dbDashBoardRepo.getTotalCount(bounds, 2);

    final total = pending + working + accepted;

    if (total == 0) return;

    resolved.value = (accepted / total) * 100;
    this.pending.value = (pending / total) * 100;
    this.working.value = (working / total) * 100;

    // resolved.value = 20.5;
    // this.pending.value = 18.5;
    // this.working.value = 2;
  }

  Future<UserModel> fetchUser(String uid) async {
    final user = await _dbDashBoardRepo.fetchUser(uid);
    return user;
  }
}
