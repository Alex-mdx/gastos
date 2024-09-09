import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:gastos/models/periodo_model.dart';
import 'package:intl/intl.dart';

import '../models/categoria_model.dart';

class GastoProvider with ChangeNotifier {
  List<CategoriaModel> _listaCategoria = [];
  List<CategoriaModel> get listaCategoria => _listaCategoria;
  set listaCategoria(List<CategoriaModel> valor) {
    _listaCategoria = valor;
    notifyListeners();
  }

  List<Uint8List> _imagenesActual = [];
  List<Uint8List> get imagenesActual => _imagenesActual;
  set imagenesActual(List<Uint8List> valor) {
    _imagenesActual = valor;
    notifyListeners();
  }

  DateTime? _selectFecha;
  DateTime? get selectFecha => _selectFecha;
  set selectFecha(DateTime? valor) {
    _selectFecha = valor;
    notifyListeners();
  }

  DateTime? _selectProxima;
  DateTime? get selectProxima => _selectProxima;
  set selectProxima(DateTime? valor) {
    _selectProxima = valor;
    notifyListeners();
  }

  GastoModelo _gastoActual = GastoModelo(
      categoriaId: null,
      monto: null,
      fecha: null,
      dia: null,
      mes: null,
      peridico: null,
      ultimaFecha: null,
      periodo:
          PeriodoModelo(year: null, mes: null, dia: null, modificable: null),
      gasto: null,
      evidencia: [],
      nota: null);
  GastoModelo get gastoActual => _gastoActual;
  set gastoActual(GastoModelo valor) {
    _gastoActual = valor;
    notifyListeners();
  }

  List<GastoModelo> _listaGastos = [];
  List<GastoModelo> get listaGastos => _listaGastos;
  set listaGastos(List<GastoModelo> valor) {
    _listaGastos = valor;
    notifyListeners();
  }

  Future<void> obtenerDato() async {
    listaCategoria = await CategoriaController.getItems();
    listaGastos = await GastosController.getItems();
  }

  ///funciones
  String convertirNumero({required double moneda}) {
    var mConvertida = NumberFormat('#,##0.####').format(moneda);
    return mConvertida;
  }

  String convertirFecha({required DateTime fecha}) {
    var fConvertida = DateFormat('yyyy-MM-dd').format(fecha);
    return fConvertida;
  }

  String convertirFechaHora({required DateTime fecha}) {
    String formatoFechaHora = DateFormat('yyyy-MM-dd HH:mm:ss').format(fecha);
    return formatoFechaHora;
  }

  String convertirHora({required DateTime fecha}) {
    String formatoFechaHora = DateFormat('HH:mm:ss').format(fecha);
    return formatoFechaHora;
  }

  double generarPago({required List<double> montos}) {
    double monto = 0.0;
    for (var element in montos) {
      monto += element;
    }
    return monto;
  }

  double promedioTotalSemana() {
    double monto = 0.0;
    for (var i = 0; i < 7; i++) {
      monto += contarSemana(
              fechas: listaGastos
                  .where((element) =>
                      DateTime.parse(element.fecha!).weekday == i + 1)
                  .map((e) => DateTime.parse(e.fecha!))
                  .toList(),
              dia: i + 1) == 0? 0: generarPago(
              montos: listaGastos
                  .where((element) =>
                      DateTime.tryParse(element.fecha!)?.weekday == i + 1)
                  .map((e) => e.monto!)
                  .toList()) /
          contarSemana(
              fechas: listaGastos
                  .where((element) =>
                      DateTime.parse(element.fecha!).weekday == i + 1)
                  .map((e) => DateTime.parse(e.fecha!))
                  .toList(),
              dia: i + 1);
    }
    return monto;
  }

  int contarSemana({required List<DateTime> fechas, required int dia}) {
    int contador = 0;
    DateTime? ultimaDate;

    for (var element in fechas) {
      if (element.weekday == dia) {
        if (ultimaDate == null || element.day != ultimaDate.day) {
          contador++;
          ultimaDate = element;
        }
      }
    }
    return contador;
  }
}
