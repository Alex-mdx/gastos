import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences? get instance => _preferences;

  static bool get islogin => _preferences?.getBool('islogin') ?? false;
  static set islogin(bool value) => _preferences?.setBool('islogin', value);

  static bool get tema => _preferences?.getBool('tema') ?? false;
  static set tema(bool value) => _preferences?.setBool('tema', value);

  static double get calidadFoto => _preferences?.getDouble('calidad_foto') ?? 75;
  static set calidadFoto(double value) => _preferences?.setDouble('calidad_foto', value);
}
