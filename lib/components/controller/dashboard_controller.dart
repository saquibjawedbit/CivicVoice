import 'dart:async';

import 'package:civic_voice/components/db/db_dashboard_repo.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final DbDashBoardRepo _dbDashBoardRepo = DbDashBoardRepo();

  var data = <ComplainModel>[].obs;

  StreamSubscription<List<ComplainModel>>? _subs;

  void listenComplainData(LatLngBounds bounds) {
    _subs?.cancel();

    final nData = _dbDashBoardRepo.listenToComplain(bounds);

    _subs = nData.listen((newData) {
      data.value = newData;
    });
  }
}
