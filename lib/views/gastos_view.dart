import 'dart:developer';

import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/utilities/apis/rutas_app.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:gastos/widgets/historial_semanal_widget.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../models/gasto_model.dart';
import '../models/periodo_model.dart';
import '../widgets/card_gasto_widget.dart';

class GastosView extends StatelessWidget {
  const GastosView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text('Gastos',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton.filled(
                      onPressed: () {
                        Navigation.pushNamed(route: AppRoutes.opciones);
                      },
                      icon: const Icon(Icons.settings, color: Colors.white)))
            ]),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(children: [
              HistorialSemanalWidget(provider: provider),
              const Divider(),
              const Column(
                  children: [Text("Recomendacion de gasto para esta semana")]),
              const Divider(),
              const Center(child: CardGastoWidget())
            ]))),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (provider.gastoActual.monto != null &&
                  provider.gastoActual.monto! > 0.0) {
                await Dialogs.showMorph(
                    title: "Ingresar gasto",
                    description: "¿Desea ingresar esta tarjeta de gasto?",
                    loadingTitle: "Ingresando...",
                    onAcceptPressed: (context) async {
                      final now = DateTime.now();
                      //?La tabla de gasto es para notificar si dicha tarjeta es modificable
                      final finalTemp = provider.gastoActual.copyWith(
                          gasto: 1,
                          fecha: provider.gastoActual.fecha ??
                              provider.convertirFechaHora(fecha: now),
                          dia: provider.gastoActual.dia ?? (now.day).toString(),
                          mes: provider.gastoActual.mes ??
                              (now.month).toString());
                      log("${finalTemp.toJson()}");
                      await GastosController.insert(finalTemp);
                      provider.listaGastos = await GastosController.getItems();
                      provider.gastoActual = GastoModelo(
                          categoriaId: null,
                          monto: null,
                          fecha: null,
                          dia: null,
                          mes: null,
                          peridico: null,
                          periodo: PeriodoModelo(
                              year: null,
                              mes: null,
                              dia: null,
                              modificable: null),
                          gasto: null,
                          evidencia: [],
                          nota: null);
                      showToast("Tarjeta de gasto Guardada con exito");
                    });
              } else {
                showToast("ingrese un monto mayor a 0");
              }
            },
            child: const Icon(Icons.savings_rounded)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
