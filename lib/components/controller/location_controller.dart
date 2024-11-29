import 'package:civic_voice/components/geolocator/geolocator_repo.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final GeolocatorRepo _geolocatorRepo = GeolocatorRepo();

  @override
  void onInit() {
    super.onInit();
    _geolocatorRepo.getAddress();
  }
}
