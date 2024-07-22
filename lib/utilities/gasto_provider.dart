import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
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

  Future<void> obtenerDato() async {
    listaCategoria = await CategoriaController.getItems();
  }
///funciones
  String convertirNumero({required double moneda}) {
    var mConvertida = NumberFormat('#,##0.####').format(moneda);
    return mConvertida;
  }
}
