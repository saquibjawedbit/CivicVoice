import 'package:civic_voice/components/utils/geolocator/geolocator_repo.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final GeolocatorRepo _geolocatorRepo = GeolocatorRepo();

  String _address = "";
  late double latitude, longitude;

  void requestPermission() async {
    debugPrint("Requesting Location Permission");
    await _geolocatorRepo.requestPermission();
  }

  Future<void> requestAddress() async {
    Position position = await _geolocatorRepo.determineLocation();

    _address = await _geolocatorRepo.getAddress(position);
    latitude = position.latitude;
    longitude = position.longitude;
  }

  String get address => _address;
  double get longs => longitude;
  double get lats => latitude;
}
