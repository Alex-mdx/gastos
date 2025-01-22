import 'package:flutter/material.dart';
import 'package:gastos/utilities/funcion_parser.dart';
import 'package:gastos/utilities/theme/theme_color.dart';

class MetodoPagoModel {
  int id;
  String nombre;
  double cambio;
  String denominacion;
  int status;
  int defecto;
  Color color;

  MetodoPagoModel(
      {required this.id,
      required this.nombre,
      required this.cambio,
      required this.denominacion,
      required this.status,
      required this.defecto,
      required this.color});

  MetodoPagoModel copyWith(
          {int? id,
          String? nombre,
          double? cambio,
          String? denominacion,
          int? status,
          int? defecto,
          Color? color}) =>
      MetodoPagoModel(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          cambio: cambio ?? this.cambio,
          denominacion: denominacion ?? this.denominacion,
          status: status ?? this.status,
          defecto: defecto ?? this.defecto,
          color: color ?? this.color);

  factory MetodoPagoModel.fromJson(Map<String, dynamic> json) =>
      MetodoPagoModel(
          id: json["id"],
          nombre: json["nombre"],
          cambio: json["cambio"]?.toDouble(),
          denominacion: json["denominacion"],
          status: Parser.toInt(json["status"]) ?? 1,
          defecto: Parser.toInt(json["defecto"]) ?? 1,
          color: Color(json["color"] ?? LightThemeColors.primary));

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "cambio": cambio,
        "denominacion": denominacion,
        "status": status,
        "defecto": defecto,
        "color": color.value
      };
}
