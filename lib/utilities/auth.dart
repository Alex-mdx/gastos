import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:oktoast/oktoast.dart';

class Auth {
  static Future<bool> obtener() async {
    final LocalAuthentication auth = LocalAuthentication();
    // ···
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Ingrese su autentificacion para eliminar sus datos',
          options: const AuthenticationOptions(useErrorDialogs: true));
      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        showToast(
            "El dispositivo no tiene soporte de hardware para la validacion biometrica");
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        showToast("No se reconoce");
      } else {
        showToast("No se reconoce");
      }
    }
    return false;
  }
}
