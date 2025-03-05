import 'dart:convert';

class BidonesModel {
  int id;
  int identificador;
  String nombre;
  double montoInicial;
  double montoFinal;
  List<int> metodoPago;
  List<int> categoria;
  DateTime fechaInicio;
  DateTime fechaFinal;
  int cerrado;

  BidonesModel(
      {required this.id,
      required this.identificador,
      required this.nombre,
      required this.montoInicial,
      required this.montoFinal,
      required this.metodoPago,
      required this.categoria,
      required this.fechaInicio,
      required this.fechaFinal,
      required this.cerrado});

  BidonesModel copyWith(
          {int? id,
          int? identificador,
          String? nombre,
          double? montoInicial,
          double? montoFinal,
          List<int>? metodoPago,
          List<int>? categoria,
          DateTime? fechaInicio,
          DateTime? fechaFinal,
          int? cerrado}) =>
      BidonesModel(
          id: id ?? this.id,
          identificador: identificador ?? this.identificador,
          nombre: nombre ?? this.nombre,
          montoInicial: montoInicial ?? this.montoInicial,
          montoFinal: montoFinal ?? this.montoFinal,
          metodoPago: metodoPago ?? this.metodoPago,
          categoria: categoria ?? this.categoria,
          fechaInicio: fechaInicio ?? this.fechaInicio,
          fechaFinal: fechaFinal ?? this.fechaFinal,
          cerrado: cerrado ?? this.cerrado);

  factory BidonesModel.fromJson(Map<String, dynamic> json) => BidonesModel(
      id: json["id"],
      identificador: json["identificador"],
      nombre: json["nombre"],
      montoInicial: double.parse(json["monto_inicial"]),
      montoFinal: double.parse(json["monto_final"]),
      metodoPago: json["metodo_pago"] == null
          ? []
          : List<int>.from(jsonDecode(json["metodo_pago"]).map((x) => x)),
      categoria: json["categoria"] == null
          ? []
          : List<int>.from(jsonDecode(json["categoria"]).map((x) => x)),
      fechaInicio: DateTime.parse(json["fecha_inicio"]),
      fechaFinal: DateTime.parse(json["fecha_final"]),
      cerrado: json["cerrado"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "identificador": identificador,
        "nombre": nombre,
        "monto_inicial": montoInicial,
        "monto_final": montoFinal,
        "metodo_pago": List<dynamic>.from(metodoPago.map((x) => x)),
        "categoria": List<dynamic>.from(categoria.map((x) => x)),
        "fecha_inicio": fechaInicio.toIso8601String(),
        "fecha_final": fechaFinal.toIso8601String(),
        "cerrado": cerrado
      };
}
