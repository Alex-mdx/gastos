import 'package:permission_handler/permission_handler.dart';

class Permisos {
  static Future<bool> notificacion() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }
}
