import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static void requestPermission() async {
    await [
      Permission.location,
      Permission.camera,
    ].request();

    if (await Permission.location.isPermanentlyDenied ||
        await Permission.camera.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enables it in the system settings.
      openAppSettings();
    }
  }
}
