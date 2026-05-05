import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:oktoast/oktoast.dart';

class Auth {
  static Future<bool> obtener() async {
    final LocalAuthentication auth = LocalAuthentication();
    
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        showToast("El dispositivo no soporta validación biométrica");
        return false;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Ingrese su autentificación para continuar'
      );
      
      if (!didAuthenticate) {
        showToast("Autenticación cancelada o fallida");
      }
      
      return didAuthenticate;
    } on PlatformException catch (e) {
        showToast("Error de autenticación: ${e.message}");
      
      return false;
    }
  }
}
