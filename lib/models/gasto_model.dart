import 'dart:convert';
import 'periodo_model.dart';

class GastoModelo {
  int? id;
  int? categoriaId;
  double? monto;
  String? fecha;
  String? dia;
  String? mes;
  int? peridico;
  String? ultimaFecha;
  PeriodoModelo periodo;
  int? gasto;
  List<String> evidencia;
  String? nota;
  int? metodoPagoId;

  GastoModelo(
      {required this.id,
      required this.categoriaId,
      required this.monto,
      required this.fecha,
      required this.dia,
      required this.mes,
      required this.peridico,
      required this.ultimaFecha,
      required this.periodo,
      required this.gasto,
      required this.evidencia,
      required this.nota,
      required this.metodoPagoId});

  GastoModelo copyWith(
          {int? id,
          int? categoriaId,
          double? monto,
          String? fecha,
          String? dia,
          String? mes,
          int? peridico,
          String? ultimaFecha,
          PeriodoModelo? periodo,
          int? gasto,
          List<String>? evidencia,
          String? nota,
          int? metodoPagoId}) =>
      GastoModelo(
          id: id ?? this.id,
          categoriaId: categoriaId ?? this.categoriaId,
          monto: monto ?? this.monto,
          fecha: fecha ?? this.fecha,
          dia: dia ?? this.dia,
          mes: mes ?? this.mes,
          peridico: peridico ?? this.peridico,
          ultimaFecha: ultimaFecha ?? this.ultimaFecha,
          periodo: periodo ?? this.periodo,
          gasto: gasto ?? this.gasto,
          evidencia: evidencia ?? this.evidencia,
          nota: nota ?? this.nota,
          metodoPagoId: metodoPagoId ?? this.metodoPagoId);

  factory GastoModelo.fromJson(Map<String, dynamic> json) => GastoModelo(
      id: json["id"],
      categoriaId: json["categoria_id"],
      monto: double.parse(json["monto"]),
      fecha: json["fecha"],
      dia: json["dia"],
      mes: json["mes"],
      peridico: json["peridico"],
      ultimaFecha: json["ultima_fecha"],
      periodo: PeriodoModelo.fromJson(jsonDecode(json["periodo"].toString())),
      gasto: json["gasto"],
      evidencia: json["evidencia"] == null
          ? []
          : List<String>.from(jsonDecode(json["evidencia"])
              .map((x) => x.toString())),
      nota: json["nota"],
      metodoPagoId: json["metodo_pago_id"] ?? 1);

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoria_id": categoriaId,
        "monto": monto,
        "fecha": fecha,
        "dia": dia,
        "mes": mes,
        "peridico": peridico,
        "ultima_fecha": ultimaFecha,
        "periodo": jsonEncode(periodo),
        "gasto": gasto,
        "evidencia": evidencia.map((x) => x.toString()).toList(),
        "nota": nota,
        "metodo_pago_id": metodoPagoId ?? 1
      };
}
