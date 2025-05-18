import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences? get instance => _preferences;

  static bool get islogin => _preferences?.getBool('islogin') ?? false;
  static set islogin(bool value) => _preferences?.setBool('islogin', value);

  static bool get promedio => _preferences?.getBool('promedio') ?? false;
  static set promedio(bool value) => _preferences?.setBool('promedio', value);

  static String get calculo => _preferences?.getString('calculo') ?? "Mensual";
  static set calculo(String value) => _preferences?.setString('calculo', value);

  static int get primerDia => _preferences?.getInt('primerDia') ?? 2;
  static set primerDia(int value) => _preferences?.setInt('primerDia', value);

  static bool get tema => _preferences?.getBool('tema') ?? false;
  static set tema(bool value) => _preferences?.setBool('tema', value);

  static String get setting =>
      _preferences?.getString('setting') ?? "-0001-11-30 01:00:00.000";
  static set setting(String value) => _preferences?.setString('setting', value);

  static double get calidadFoto =>
      _preferences?.getDouble('calidad_foto') ?? 75;
  static set calidadFoto(double value) =>
      _preferences?.setDouble('calidad_foto', value);

  static String get tokenDropbox =>
      _preferences?.getString('tokenDropbox') ?? "";
  static set tokenDropbox(String value) =>
      _preferences?.setString('tokenDropbox', value);

  static String get recordatorio1 =>
      _preferences?.getString('recordatorio1') ?? "21:00";
  static set recordatorio1(String value) =>
      _preferences?.setString('recordatorio1', value);

  static String get recordatorio2 =>
      _preferences?.getString('recordatorio2') ?? "13:00";
  static set recordatorio2(String value) =>
      _preferences?.setString('recordatorio2', value);
}
