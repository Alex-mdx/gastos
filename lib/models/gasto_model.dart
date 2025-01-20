import 'dart:convert';
import 'dart:typed_data';

import 'package:gastos/utilities/funcion_parser.dart';

import 'periodo_model.dart';

class GastoModelo {
  int? id;
  int? categoriaId;
  int? metodoPagoId;
  double? monto;
  String? fecha;
  String? dia;
  String? mes;
  int? peridico;
  String? ultimaFecha;
  PeriodoModelo periodo;
  int? gasto;
  List<Uint8List> evidencia;
  String? nota;

  GastoModelo(
      {required this.id,
      required this.categoriaId,
      required this.metodoPagoId,
      required this.monto,
      required this.fecha,
      required this.dia,
      required this.mes,
      required this.peridico,
      required this.ultimaFecha,
      required this.periodo,
      required this.gasto,
      required this.evidencia,
      required this.nota});

  GastoModelo copyWith(
          {int? id,
          int? categoriaId,
          int? metodoPagoId,
          double? monto,
          String? fecha,
          String? dia,
          String? mes,
          int? peridico,
          String? ultimaFecha,
          PeriodoModelo? periodo,
          int? gasto,
          List<Uint8List>? evidencia,
          String? nota}) =>
      GastoModelo(
          id: id ?? this.id,
          categoriaId: categoriaId ?? this.categoriaId,
          metodoPagoId: metodoPagoId ?? this.metodoPagoId,
          monto: monto ?? this.monto,
          fecha: fecha ?? this.fecha,
          dia: dia ?? this.dia,
          mes: mes ?? this.mes,
          peridico: peridico ?? this.peridico,
          ultimaFecha: ultimaFecha ?? this.ultimaFecha,
          periodo: periodo ?? this.periodo,
          gasto: gasto ?? this.gasto,
          evidencia: evidencia ?? this.evidencia,
          nota: nota ?? this.nota);

  factory GastoModelo.fromJson(Map<String, dynamic> json) => GastoModelo(
      id: json["id"],
      categoriaId: json["categoria_id"],
      metodoPagoId:json["metodo_pago_id"] ?? 1,
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
          : List<Uint8List>.from(jsonDecode(json["evidencia"])
              .map((x) => Parser.toUint8List(x.toString()))),
      nota: json["nota"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoria_id": categoriaId,
        "metodo_pago_id": metodoPagoId ?? 1,
        "monto": monto,
        "fecha": fecha,
        "dia": dia,
        "mes": mes,
        "peridico": peridico,
        "ultima_fecha": ultimaFecha,
        "periodo": jsonEncode(periodo),
        "gasto": gasto,
        "evidencia": jsonEncode(evidencia.map((x) => x.toString()).toList()),
        "nota": nota
      };
}
