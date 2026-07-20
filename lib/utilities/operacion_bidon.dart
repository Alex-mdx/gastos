import 'dart:developer';
import 'dart:typed_data';
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
    // Obtenemos solo los bidones que coinciden inicialmente
    List<BidonesModel> coincidencias =
        await BidonesController.buscarCoincidencia(
            gasto.metodoPagoId!, gasto.categoriaId!);

    for (var bidon in coincidencias) {
      await _procesarDescuento(bidon, gasto, resta);
    }
  }

  // Función recursiva para procesar el gasto y sus remanentes en nuevos bidones
  static Future<void> _procesarDescuento(
      BidonesModel bidon, GastoModelo gasto, double resta) async {
    final now = DateTime.now();
    double nuevoMonto = bidon.montoFinal - resta;

    // Regla 1: Guardar el id del gasto
    List<int> nuevosGastos = [...bidon.gastos];
    if (!nuevosGastos.contains(gasto.id!)) {
      nuevosGastos.add(gasto.id!);
    }

    // Reglas 2, 3 y 4: Validar si este bidón tiene permitido crear uno nuevo al llegar a 0
    bool coincideDia =
        bidon.diasEfecto.isEmpty || bidon.diasEfecto.contains(now.weekday - 1);
    bool coincideCategoria =
        bidon.categoria.isEmpty || bidon.categoria.contains(gasto.categoriaId);
    bool coincideMetodo = bidon.metodoPago.isEmpty ||
        bidon.metodoPago.contains(gasto.metodoPagoId);

    // Solo si cumple TODAS las condiciones establecidas podrá hacer rollover
    bool permiteRollover = coincideDia && coincideCategoria && coincideMetodo;

    if (nuevoMonto >= 0 || !permiteRollover) {
      // Si hay saldo, o si NO se permite rollover (queda en negativo)
      var actualizado = bidon.copyWith(
          fechaFinal: now, gastos: nuevosGastos, montoFinal: nuevoMonto);
      await BidonesController.update(actualizado);
    } else {
      // Regla 1: Limitar a 0 el monto final actual
      showToast("Ha vaciado el bidón ${bidon.nombre}");
      var bidonCerrado = bidon.copyWith(
          fechaFinal: now, gastos: nuevosGastos, montoFinal: 0, cerrado: 1);
      await BidonesController.update(bidonCerrado);

      // Crear el nuevo bidón para la diferencia restada
      double restante = nuevoMonto.abs();
      BidonesModel nuevoBidon = BidonesModel(
          identificador: bidon.identificador,
          nombre: bidon.nombre,
          montoInicial: bidon.montoInicial,
          montoFinal:
              bidon.montoInicial, // Iniciamos lleno, se restará en la recursión
          metodoPago: bidon.metodoPago,
          categoria: bidon.categoria,
          diasEfecto: bidon.diasEfecto,
          fechaInicio: now,
          fechaFinal: now,
          cerrado: 0,
          inhabilitado: 0,
          gastos: [] // Los gastos se agregan en la llamada recursiva
          );

      await BidonesController.insert(nuevoBidon);
      List<BidonesModel> bidones =
          await BidonesController.getItemsByPersonalizado(
              query: "identificador = ? and cerrado = ?",
              args: [nuevoBidon.identificador, nuevoBidon.cerrado.toString()]);
      nuevoBidon = bidones.first;

      // Llamada recursiva: si el sobrante supera el nuevo bidón, volverá a dividirse
      await _procesarDescuento(nuevoBidon, gasto, restante);
    }
  }

  static Future<void> actualizar({required int id}) async {
    final bidonBase = await BidonesController.getItem(id: id);
    if (bidonBase == null) {
      showToast("No se encontró el bidón solicitado");
      return;
    }

    // Regla 5: Para retroceder, crear o eliminar bidones de forma segura,
    // reconstruimos toda la cadena asociada a ese identificador.

    // 1. Obtener la familia de bidones ordenados por creación
    List<BidonesModel> cadena = await BidonesController.getItemsByPersonalizado(
        query: "identificador = ?", args: [bidonBase.identificador]);
    if (cadena.isEmpty) return;
    cadena.sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));

    // 2. Extraer todos los IDs de gastos únicos registrados en esta cadena
    Set<int> todosLosGastosIds = {};
    for (var b in cadena) {
      todosLosGastosIds.addAll(b.gastos);
    }

    // 3. Verificar en DB cuáles gastos siguen vivos
    List<GastoModelo> gastosValidos = [];
    for (var gastoId in todosLosGastosIds) {
      // Asegúrate de que find te devuelva el modelo completo con categoriaId y metodoPagoId
      var gasto = await GastosController.find(
          gastoId, ["id", "monto", "categoriaId", "metodoPagoId"]);
      if (gasto != null) gastosValidos.add(gasto);
    }

    if (gastosValidos.isEmpty) {
      showToast("Este bidón ya no tiene gastos activos");
    }

    // 4. Restaurar el primer bidón a su estado virgen
    BidonesModel primerBidon = cadena.first;
    var bidonReiniciado = primerBidon.copyWith(
        montoFinal: primerBidon.montoInicial, gastos: [], cerrado: 0);
    await BidonesController.update(bidonReiniciado);

    // 5. Eliminar los bidones extra (rollovers) que ya no estamos seguros si se necesitan
    for (int i = 1; i < cadena.length; i++) {
      await BidonesController.deleteId(cadena[i].id!);
    }

    // 6. Volver a aplicar los gastos válidos cronológicamente
    for (var gasto in gastosValidos) {
      // Siempre inyectamos el gasto en el *último* bidón de la cadena actual
      List<BidonesModel> cadenaActual =
          await BidonesController.getItemsByPersonalizado(
              query: "identificador = ? and cerrado = ?",
              args: [
            bidonReiniciado.identificador,
            bidonReiniciado.cerrado.toString()
          ]);
      cadenaActual.sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));

      // Usamos nuestra lógica centralizada que automáticamente creará bidones si es necesario
      await _procesarDescuento(cadenaActual.last, gasto, gasto.monto ?? 0);
    }

    log("Bidón y cadena actualizados correctamente");
  }
}
