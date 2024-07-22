import 'dart:convert';
import 'dart:typed_data';

import 'periodo_model.dart';

class GastoModelo {
    int id;
    int categoriaId;
    double monto;
    String fecha;
    String dia;
    String mes;
    int peridico;
    PeriodoModelo periodo;
    int gasto;
    List<Uint8List> evidencia;

    GastoModelo({
        required this.id,
        required this.categoriaId,
        required this.monto,
        required this.fecha,
        required this.dia,
        required this.mes,
        required this.peridico,
        required this.periodo,
        required this.gasto,
        required this.evidencia,
    });

    GastoModelo copyWith({
        int? id,
        int? categoriaId,
        double? monto,
        String? fecha,
        String? dia,
        String? mes,
        int? peridico,
        PeriodoModelo? periodo,
        int? gasto,
        List<Uint8List>? evidencia,
    }) => 
        GastoModelo(
            id: id ?? this.id,
            categoriaId: categoriaId ?? this.categoriaId,
            monto: monto ?? this.monto,
            fecha: fecha ?? this.fecha,
            dia: dia ?? this.dia,
            mes: mes ?? this.mes,
            peridico: peridico ?? this.peridico,
            periodo: periodo ?? this.periodo,
            gasto: gasto ?? this.gasto,
            evidencia: evidencia ?? this.evidencia,
        );

    factory GastoModelo.fromJson(Map<String, dynamic> json) => GastoModelo(
        id: json["id"],
        categoriaId: json["categoria_id"],
        monto: json["monto"]?.toDouble(),
        fecha: json["fecha"],
        dia: json["dia"],
        mes: json["mes"],
        peridico: json["peridico"],
        periodo: PeriodoModelo.fromJson(jsonDecode(json["periodo"])),
        gasto: json["gasto"],
        evidencia: List<Uint8List>.from(json["evidencia"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "categoria_id": categoriaId,
        "monto": monto,
        "fecha": fecha,
        "dia": dia,
        "mes": mes,
        "peridico": peridico,
        "periodo": periodo,
        "gasto": jsonEncode(gasto),
        "evidencia": List<Uint8List>.from(evidencia.map((x) => x)),
    };
}