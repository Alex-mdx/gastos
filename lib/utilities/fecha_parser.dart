import 'package:intl/intl.dart';

class FechaParser {
  static String convertirFecha({required DateTime fecha}) {
    var fConvertida = DateFormat('yyyy-MM-dd').format(fecha);
    return fConvertida;
  }

  static String convertirFechaHora({required DateTime fecha}) {
    String formatoFechaHora = DateFormat('yyyy-MM-dd HH:mm:ss').format(fecha);
    return formatoFechaHora;
  }

  static String convertirHora({required DateTime fecha}) {
    String formatoFechaHora = DateFormat('HH:mm:ss').format(fecha);
    return formatoFechaHora;
  }
}