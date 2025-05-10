import 'dart:developer';

import 'package:gastos/controllers/bidones_controller.dart';
import 'package:gastos/models/gasto_model.dart';

import '../models/bidones_model.dart';

class OperacionBidon {
  static restador(GastoModelo gasto) async {
    List<BidonesModel> coincidencias =
        await BidonesController.buscarCoincidencia(
            gasto.metodoPagoId!, gasto.categoriaId!);
    for (var bidon in coincidencias) {
      List<int> addGasto = [...bidon.categoria, gasto.id!];
      final now = DateTime.now();
      var resta = bidon.montoFinal - (gasto.monto ?? 0);
      log("$resta");
      if (resta >= 0) {
        var restar = bidon.copyWith(
            fechaFinal: now, gastos: addGasto, montoFinal: resta);
        log("$restar");
      } else {
        if (bidon.diasEfecto.where((dias) => dias == now.weekday).isNotEmpty) {}
        //log("$restar");
      }
    }
  }
}
