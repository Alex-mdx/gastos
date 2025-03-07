import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/controllers/presupuesto_controller.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:gastos/models/metodo_pago_model.dart';
import 'package:gastos/models/periodo_model.dart';
import 'package:gastos/models/presupuesto_model.dart';
import 'package:gastos/utilities/fecha_parser.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:get/get.dart';
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
      id: null,
      categoriaId: null,
      metodoPagoId: null,
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

  PresupuestoModel? _presupuesto;
  PresupuestoModel? get presupuesto => _presupuesto;
  set presupuesto(PresupuestoModel? valor) {
    _presupuesto = valor;
    notifyListeners();
  }

  TextEditingController _notas = TextEditingController();
  TextEditingController get notas => _notas;
  set notas(TextEditingController valor) {
    _notas = valor;
    notifyListeners();
  }

  List<MetodoPagoModel> _metodo = [];
  List<MetodoPagoModel> get metodo => _metodo;
  set metodo(List<MetodoPagoModel> valor) {
    _metodo = valor;
    notifyListeners();
  }

  MetodoPagoModel? _metodoSelect;
  MetodoPagoModel? get metodoSelect => _metodoSelect;
  set metodoSelect(MetodoPagoModel? valor) {
    _metodoSelect = valor;
    notifyListeners();
  }

  bool _internet = false;
  bool get internet => _internet;
  set internet(bool valor) {
    _internet = valor;
    notifyListeners();
  }

  Future<void> obtenerDato() async {
    listaCategoria = await CategoriaController.getItems();
    listaGastos = await GastosController.getConfigurado();
    presupuesto = await PresupuestoController.getItem();
    await MetodoGastoController.generarObtencion();
    metodo = await MetodoGastoController.getItems();
    metodoSelect = metodo.firstWhereOrNull((element) => element.defecto == 1);
    //DropboxGen.verificarLogeo();
  }

  ///funciones
  String convertirNumero({required double moneda}) {
    var mConvertida = NumberFormat('#,##0.####').format(moneda);
    return mConvertida;
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
    var newGastos = listaGastos;
    if (Preferences.promedio) {
      newGastos = gastosFiltrados(listaGastos);
    }
    for (var i = 0; i < 7; i++) {
      var sumatoria = contarSemana(
          fechas: newGastos
              .where(
                  (element) => DateTime.parse(element.fecha!).weekday == i + 1)
              .map((e) => DateTime.parse(e.fecha!))
              .toList(),
          dia: i);
      monto += sumatoria == 0
          ? 0
          : generarPago(
                  montos: newGastos
                      .where((element) =>
                          DateTime.tryParse(element.fecha!)?.weekday == i + 1)
                      .map((e) => e.monto!)
                      .toList()) /
              sumatoria;
    }
    return monto;
  }

  double promediarDiaSemana(int index) {
    var newGastos = listaGastos;
    if (Preferences.promedio) {
      newGastos = gastosFiltrados(listaGastos);
    }
    return contarSemana(
                fechas: newGastos.map((e) => DateTime.parse(e.fecha!)).toList(),
                dia: index) ==
            0
        ? 0 // si no hay datos mete 0
        : (generarPago(
                montos: newGastos
                    .where((element) =>
                        DateTime.tryParse(element.fecha!)?.weekday == index + 1)
                    .map((e) => e.monto!)
                    .toList())) /
            (contarSemana(
                fechas: newGastos.map((e) => DateTime.parse(e.fecha!)).toList(),
                dia: index));
  }

  double sumatoriaDiaCalendario(DateTime fecha, List<GastoModelo> gasto) {
    return generarPago(
        montos: gasto
            .where((element) => DateTime(
                    DateTime.parse(element.fecha!).year,
                    DateTime.parse(element.fecha!).month,
                    DateTime.parse(element.fecha!).day)
                .isAtSameMomentAs(fecha))
            .map((e) => e.monto!)
            .toList());
  }

  double sumatoriaDia(DateTime fecha) {
    return generarPago(
        montos: listaGastos
            .where((element) => DateTime(
                    DateTime.parse(element.fecha!).year,
                    DateTime.parse(element.fecha!).month,
                    DateTime.parse(element.fecha!).day)
                .isAtSameMomentAs(fecha))
            .map((e) => e.monto!)
            .toList());
  }

  int contarSemana({required List<DateTime> fechas, required int dia}) {
    int contador = 0;
    DateTime? ultimaDate;
    for (var element in fechas) {
      if (element.weekday == dia + 1) {
        if (ultimaDate == null || element.day != ultimaDate.day) {
          contador++;
          ultimaDate = element;
        }
      }
    }
    return contador;
  }

  List<GastoModelo> gastosFiltrados(List<GastoModelo> actuales) {
    DateTime ahora = DateTime.now();
    int diaSemanaActual = ahora.weekday;
    DateTime inicioSemana = DateTime.parse(FechaParser.convertirFecha(
        fecha: ahora.subtract(Duration(days: diaSemanaActual - 1))));
    DateTime finSemana = DateTime(
        DateTime.parse(FechaParser.convertirFecha(
                fecha: inicioSemana.add(const Duration(days: 7))))
            .year,
        DateTime.parse(FechaParser.convertirFecha(
                fecha: inicioSemana.add(const Duration(days: 7))))
            .month,
        DateTime.parse(FechaParser.convertirFecha(
                fecha: inicioSemana.add(const Duration(days: 7))))
            .day,
        23,
        59,
        59);
    return listaGastos
        .where((element) =>
            (DateTime.parse(element.fecha!).isAfter(inicioSemana) ||
                DateTime.parse(element.fecha!)
                    .isAtSameMomentAs(inicioSemana)) &&
            ((DateTime.parse(element.fecha!).isAtSameMomentAs(finSemana) ||
                (DateTime.parse(element.fecha!).isBefore(finSemana)))))
        .toList();
  }

  double obtenerPorcentajeDia(int index, double monto) {
    switch (index) {
      case 0:
        return monto == 0 ? 0 : ((100 * monto) / (presupuesto?.lunes ?? 0));
      case 1:
        return monto == 0 ? 0 : ((100 * monto) / (presupuesto?.martes ?? 0));
      case 2:
        return monto == 0 ? 0 : ((100 * monto) / (presupuesto?.miercoles ?? 0));
      case 3:
        return monto == 0 ? 0 : ((100 * monto) / (presupuesto?.jueves ?? 0));
      case 4:
        return monto == 0 ? 0 : ((100 * monto) / (presupuesto?.viernes ?? 0));
      case 5:
        return monto == 0 ? 0 : ((100 * monto) / (presupuesto?.sabado ?? 0));
      case 6:
        return monto == 0 ? 0 : ((100 * monto) / (presupuesto?.domingo ?? 0));
      default:
        return -1;
    }
  }

  Color porcentualColor(double monto) {
    if (monto == 0) {
      return LightThemeColors.darkBlue;
    } else if (monto < 25) {
      return LightThemeColors.primary;
    } else if (monto >= 25 && monto < 50) {
      return LightThemeColors.green;
    } else if (monto >= 50 && monto < 75) {
      return LightThemeColors.yellow;
    } else if (monto >= 75 && monto < 100) {
      return LightThemeColors.red;
    } else {
      return LightThemeColors.purple;
    }
  }
}
