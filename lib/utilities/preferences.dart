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

  static double get calidadFoto =>
      _preferences?.getDouble('calidad_foto') ?? 80;
  static set calidadFoto(double value) =>
      _preferences?.setDouble('calidad_foto', value);
}
