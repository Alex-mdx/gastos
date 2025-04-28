import 'dart:convert';

class BidonesModel {
  int id;
  String identificador;
  String nombre;
  double montoInicial;
  double montoFinal;
  List<int> metodoPago;
  List<int> categoria;
  List<int> diasEfecto;
  DateTime fechaInicio;
  DateTime fechaFinal;
  int cerrado;
  List<int> gastos;

  BidonesModel(
      {required this.id,
      required this.identificador,
      required this.nombre,
      required this.montoInicial,
      required this.montoFinal,
      required this.metodoPago,
      required this.categoria,
      required this.diasEfecto,
      required this.fechaInicio,
      required this.fechaFinal,
      required this.cerrado,
      required this.gastos});

  BidonesModel copyWith(
          {int? id,
          String? identificador,
          String? nombre,
          double? montoInicial,
          double? montoFinal,
          List<int>? metodoPago,
          List<int>? categoria,
          List<int>? diasEfecto,
          DateTime? fechaInicio,
          DateTime? fechaFinal,
          int? cerrado,
          List<int>? gastos}) =>
      BidonesModel(
          id: id ?? this.id,
          identificador: identificador ?? this.identificador,
          nombre: nombre ?? this.nombre,
          montoInicial: montoInicial ?? this.montoInicial,
          montoFinal: montoFinal ?? this.montoFinal,
          metodoPago: metodoPago ?? this.metodoPago,
          categoria: categoria ?? this.categoria,
          diasEfecto: diasEfecto ?? this.diasEfecto,
          fechaInicio: fechaInicio ?? this.fechaInicio,
          fechaFinal: fechaFinal ?? this.fechaFinal,
          cerrado: cerrado ?? this.cerrado,
          gastos: gastos ?? this.gastos);

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
      diasEfecto: json["dias_efecto"] == null
          ? []
          : List<int>.from(jsonDecode(json["dias_efecto"]).map((x) => x)),
      fechaInicio: DateTime.parse(json["fecha_inicio"]),
      fechaFinal: DateTime.parse(json["fecha_final"]),
      cerrado: json["cerrado"],
      gastos: json["gastos"] == null
          ? []
          : List<int>.from(jsonDecode(json["gastos"]).map((x) => x)));

  Map<String, dynamic> toJson() => {
        "id": id,
        "identificador": identificador,
        "nombre": nombre,
        "monto_inicial": montoInicial,
        "monto_final": montoFinal,
        "metodo_pago": List<int>.from(metodoPago.map((x) => x)),
        "categoria": List<int>.from(categoria.map((x) => x)),
        "dias_efecto": List<int>.from(diasEfecto.map((x) => x)),
        "fecha_inicio": fechaInicio.toIso8601String(),
        "fecha_final": fechaFinal.toIso8601String(),
        "cerrado": cerrado,
        "gastos": List<int>.from(metodoPago.map((x) => x))
      };
}
