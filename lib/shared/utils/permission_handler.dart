import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<bool> requestCamera() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isPermanentlyDenied) openAppSettings();
    return status.isLimited || status.isLimited;
  }

  Future<bool> checkCamera() async {
    PermissionStatus status = await Permission.camera.status;
    return status.isLimited || status.isGranted;
  }
}
