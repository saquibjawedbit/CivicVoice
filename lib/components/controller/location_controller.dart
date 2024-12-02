import 'package:civic_voice/components/utils/geolocator/geolocator_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final GeolocatorRepo _geolocatorRepo = GeolocatorRepo();

  String _address = "";

  void requestPermission() async {
    debugPrint("Requesting Location Permission");
    await _geolocatorRepo.requestPermission();
  }

  Future<void> requestAddress() async {
    _address = await _geolocatorRepo.getAddress();
  }

  String get address => _address;
}
