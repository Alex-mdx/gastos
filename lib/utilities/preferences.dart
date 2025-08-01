import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences? get instance => _preferences;

  static bool get islogin => _preferences?.getBool('islogin') ?? false;
  static set islogin(bool value) => _preferences?.setBool('islogin', value);

  static bool get promedio => _preferences?.getBool('promedio') ?? true;
  static set promedio(bool value) => _preferences?.setBool('promedio', value);

  static String get calculo => _preferences?.getString('calculo') ?? "Mensual";
  static set calculo(String value) => _preferences?.setString('calculo', value);

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
      _preferences?.getString('recordatorio1') ?? "12:30";
  static set recordatorio1(String value) =>
      _preferences?.setString('recordatorio1', value);
  static bool get recordatorioAct1 =>
      _preferences?.getBool('recordatorioAct1') ?? false;
  static set recordatorioAct1(bool value) =>
      _preferences?.setBool('recordatorioAct1', value);

  static String get recordatorio2 =>
      _preferences?.getString('recordatorio2') ?? "21:30";
  static set recordatorio2(String value) =>
      _preferences?.setString('recordatorio2', value);
  static bool get recordatorioAct2 =>
      _preferences?.getBool('recordatorioAct2') ?? false;
  static set recordatorioAct2(bool value) =>
      _preferences?.setBool('recordatorioAct2', value);

  static bool get thema => _preferences?.getBool('thema') ?? true;
  static set thema(bool value) => _preferences?.setBool('thema', value);
  
  static bool get version => _preferences?.getBool('version') ?? true;
  static set version(bool value) => _preferences?.setBool('version', value);
}
