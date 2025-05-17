import 'dart:developer';

import 'package:gastos/controllers/bidones_controller.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:oktoast/oktoast.dart';

import '../models/bidones_model.dart';

class OperacionBidon {
  static Future<void> restador(
      {required GastoModelo gasto, required double resta}) async {
    List<BidonesModel> coincidencias =
        await BidonesController.buscarCoincidencia(
            gasto.metodoPagoId!, gasto.categoriaId!);
    for (var bidon in coincidencias) {
      List<int> addGasto = [...bidon.categoria, gasto.id!];
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
            id: await BidonesController.getLastId(),
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
}
