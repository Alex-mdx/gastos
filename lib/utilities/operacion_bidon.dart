import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/bidones_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:oktoast/oktoast.dart';

import '../models/bidones_model.dart';
import 'image_gen.dart';
import 'textos.dart';

class OperacionGasto {
  static Future<void> gasto(
      {required GastoModelo gasto,
      required int metodoPago,
      required DateTime? newTime,
      required List<Uint8List> evidencia,
      required String? notas}) async {
    final now = DateTime.now();
    var id = (await GastosController.getLastId());
    //generar files en biblioteca
    List<String> names = [];
    for (var i = 0; i < evidencia.length; i++) {
      await ImageGen.generar(archivo: evidencia[i], name: "gasto_${i + 1}_$id");
      names.add("gasto_${i + 1}_$id.jpg");
    }
    //?La tabla de gasto es para notificar si dicha tarjeta es modificable
    final finalTemp = gasto.copyWith(
        id: id,
        metodoPagoId: metodoPago,
        gasto: 1,
        nota: notas,
        ultimaFecha: null,
        fecha: newTime != null
            ? Textos.fechaYMDHMS(fecha: newTime)
            : Textos.fechaYMDHMS(fecha: now),
        dia: (newTime?.day ?? now.day).toString(),
        mes: (newTime?.month ?? now.month).toString(),
        evidencia: names);
    log("${finalTemp.toJson()}");
    await OperacionGasto.restador(gasto: finalTemp, resta: finalTemp.monto!);
    await GastosController.insert(finalTemp);
  }

  static Future<void> restador(
      {required GastoModelo gasto, required double resta}) async {
    List<BidonesModel> coincidencias =
        await BidonesController.buscarCoincidencia(
            gasto.metodoPagoId!, gasto.categoriaId!);
    for (var bidon in coincidencias) {
      List<int> addGasto = [...bidon.gastos, gasto.id!];
      final now = DateTime.now();
      var montoRestado = bidon.montoFinal - (resta);
      log("${bidon.toJson()}\nRestado: $montoRestado");
      if (montoRestado >= 0) {
        var objeto = bidon.copyWith(
            fechaFinal: now, gastos: addGasto, montoFinal: montoRestado);

        await BidonesController.update(objeto);
      } else {
        showToast("ha vaciado el bidon ${bidon.nombre}");
        var objetoSaldado =
            bidon.copyWith(fechaFinal: now, gastos: addGasto, montoFinal: 0);
        BidonesModel newBidon = BidonesModel(
            identificador: bidon.identificador,
            nombre: bidon.nombre,
            montoInicial: bidon.montoInicial,
            montoFinal: bidon.montoInicial,
            metodoPago: bidon.metodoPago,
            categoria: bidon.categoria,
            diasEfecto: bidon.diasEfecto,
            fechaInicio: now,
            fechaFinal: now,
            cerrado: 0,
            inhabilitado: 0,
            gastos: addGasto);
        double newResta = (bidon.montoInicial - montoRestado.abs());
        log("restaLoop: $newResta");
        if (bidon.diasEfecto.isNotEmpty) {
          if (bidon.diasEfecto.contains(now.weekday - 1)) {
            final cerrar = objetoSaldado.copyWith(cerrado: 1);
            await BidonesController.update(cerrar);
            if (newResta >= 0) {
              final restado = newBidon.copyWith(montoFinal: newResta);
              await BidonesController.insert(restado);
            } else {
              await BidonesController.insert(newBidon);
              await restador(gasto: gasto, resta: montoRestado.abs());
            }
          } else {
            final restarObjeto = objetoSaldado.copyWith(
                montoFinal: objetoSaldado.montoFinal - montoRestado.abs());
            await BidonesController.update(restarObjeto);
          }
        } else {
          log("Sin dias");
          final cerrar = objetoSaldado.copyWith(cerrado: 1);
          await BidonesController.update(cerrar);
          if (newResta >= 0) {
            final restado = newBidon.copyWith(montoFinal: newResta);
            await BidonesController.insert(restado);
          } else {
            await BidonesController.insert(newBidon);
            await restador(gasto: gasto, resta: montoRestado.abs());
          }
        }
      }
    }
  }

  static Future<void> actualizar({required int id}) async {
    final bidon = await BidonesController.getItem(id: id);
    if (bidon != null) {
      if (bidon.gastos.isNotEmpty) {
        double sumador = 0.0;
        List<int> gastosId = bidon.gastos;
        debugPrint("gastosId");
        var modificableGasto = gastosId.map((e) => e).toList();
        //Verificar la existencia de cada gasto
        for (var element in gastosId) {
          var gasto = await GastosController.find(element, ["id", "monto"]);
          sumador += gasto?.monto ?? 0;
          if (gasto == null) {
            modificableGasto.remove(element);
          }
        }
        var newBidon = bidon.copyWith(
            gastos: modificableGasto, montoFinal: bidon.montoInicial - sumador);
        await BidonesController.update(newBidon);
        log("${newBidon.toJson()}");
        log("bidon actualizado");
      } else {
        showToast("Este bidon no tiene gastos que verificar");
      }
    } else {
      showToast("No se encontro el bidon solicitado");
    }
  }
}
