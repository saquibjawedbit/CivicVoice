import 'package:civic_voice/components/controller/dashboard_controller.dart';
import 'package:civic_voice/components/models/complain_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final DashboardController _controller = Get.find();

  double lats = 23.416209;
  double longs = 85.438434;

  final MapController _mapController = MapController();
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.blue[100],
        child: Obx(() {
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(lats, longs),
              initialZoom: 14,
              minZoom: 12,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onPositionChanged: (camera, gesture) {
                _controller.listenComplainData(camera.visibleBounds);
              },
              onMapReady: () => _controller
                  .listenComplainData(_mapController.camera.visibleBounds),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              // Add hotspot regions
              MarkerLayer(
                markers: (_controller.data)
                    .map(
                      (ComplainModel data) => _markers(
                        data.latitude,
                        data.longitude,
                        (data.status == 0) ? Colors.red : Colors.yellow,
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        }),
      ),
    );
  }

  Marker _markers(double lat, double long, Color color) {
    return Marker(
      point: LatLng(lat, long),
      width: 10,
      height: 10,
      child: Icon(
        Icons.location_on,
        color: color,
      ),
    );
  }
}
