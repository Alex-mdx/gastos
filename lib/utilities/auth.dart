import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:oktoast/oktoast.dart';

class Auth {
  static Future<bool> obtener() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (availableBiometrics.isNotEmpty) {
      showToast(
          "Por favor, autentica tu acceso con tu método de seguridad biométrica para proteger tu información\nIngresa algun Pin, Contraseña, Huella Dacticar, etc.");
      return false;
    }
    if (!canAuthenticate) {
      showToast("Su dispositivo no soporta la autentificacion biometrica");
      return false;
    }

    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason:
              'Ingrese su autentificacion para eliminar sus datos');
      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        showToast(
            "El dispositivo no tiene soporte de hardware para datos biométricos");
        return false;
      } else if (e.code == auth_error.notEnrolled) {
        showToast(
            "el usuario no ha registrado ningún dato biométrico en el dispositivo");
        return false;
      } else {
        log("$e");
        showToast("$e");
        return false;
      }
    }
  }
}
