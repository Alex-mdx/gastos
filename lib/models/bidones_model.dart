import 'dart:convert';

class BidonesModel {
  int? id;
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
  int inhabilitado;
  List<int> gastos;

  BidonesModel(
      {this.id,
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
      required this.inhabilitado,
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
          int? inhabilitado,
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
          inhabilitado: inhabilitado ?? this.inhabilitado,
          gastos: gastos ?? this.gastos);

  factory BidonesModel.fromJson(Map<String, dynamic> json) => BidonesModel(
      id: json["id"],
      identificador: json["identificador"],
      nombre: json["nombre"],
      montoInicial: double.parse(json["monto_inicial"].toString()),
      montoFinal: double.parse(json["monto_final"].toString()),
      metodoPago: json["metodo_pago"] == null
          ? []
          : List<int>.from(
              jsonDecode(json["metodo_pago"].toString()).map((x) => x)),
      categoria: json["categoria"] == null
          ? []
          : List<int>.from(
              jsonDecode(json["categoria"].toString()).map((x) => x)),
      diasEfecto: json["dias_efecto"] == null
          ? []
          : List<int>.from(
              jsonDecode(json["dias_efecto"].toString()).map((x) => x)),
      fechaInicio: DateTime.parse(json["fecha_inicio"]),
      fechaFinal: DateTime.parse(json["fecha_final"]),
      cerrado: json["cerrado"],
      inhabilitado: json["inhabilitado"],
      gastos: json["gastos"] == null
          ? []
          : List<int>.from(
              jsonDecode(json["gastos"].toString()).map((x) => x)));

  Map<String, dynamic> toJson() => {
        "id": id,
        "identificador": identificador,
        "nombre": nombre,
        "monto_inicial": montoInicial,
        "monto_final": montoFinal,
        "metodo_pago": jsonEncode(metodoPago),
        "categoria": jsonEncode(categoria),
        "dias_efecto": jsonEncode(diasEfecto),
        "fecha_inicio": fechaInicio.toIso8601String(),
        "fecha_final": fechaFinal.toIso8601String(),
        "cerrado": cerrado,
        "inhabilitado": inhabilitado,
        "gastos": jsonEncode(gastos)
      };
}
