import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/models/periodo_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DialogPeriodoGasto extends StatefulWidget {
  final GastoProvider provider;
  const DialogPeriodoGasto({super.key, required this.provider});

  @override
  State<DialogPeriodoGasto> createState() => _DialogPeriodoGastoState();
}

class _DialogPeriodoGastoState extends State<DialogPeriodoGasto> {
  double dia = 0;
  double mes = 0;
  double year = 0;
  bool modificable = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text("Seleccione el periodo"),
              Column(children: [
                const Row(children: [
                  Expanded(
                      child: Text("Dia",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text("Mes",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text("Año",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)))
                ]),
                SizedBox(
                    height: 25.h,
                    child: Row(children: [
                      Expanded(
                          child: SpinBox(
                              min: 0,
                              max: 30,
                              value: double.parse(
                                  provider.gastoActual.periodo.dia ??
                                      dia.toString()),
                              acceleration: 1,
                              direction: Axis.vertical,
                              onChanged: (value) => dia = value)),
                      Expanded(
                          child: SpinBox(
                              min: 0,
                              max: 11,
                              value: double.parse(
                                  provider.gastoActual.periodo.mes ??
                                      mes.toString()),
                              acceleration: 1,
                              direction: Axis.vertical,
                              onChanged: (value) => mes = value)),
                      Expanded(
                          child: SpinBox(
                              min: 0,
                              max: 10,
                              value: double.parse(
                                  provider.gastoActual.periodo.year ??
                                      year.toString()),
                              acceleration: 1,
                              direction: Axis.vertical,
                              onChanged: (value) => year = value))
                    ]))
              ]),
              Center(
                  child: Container(
                      color: LightThemeColors.second,
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(children: [
                            const Text("Modificable"),
                            Checkbox(
                                value: modificable,
                                onChanged: (value) {
                                  setState(() {
                                    modificable = !modificable;
                                  });
                                })
                          ])))),
              ElevatedButton.icon(
                  onPressed: () async {
                    if (((year == 0 ||
                            (double.parse(
                                    provider.gastoActual.periodo.year ?? '0') ==
                                0)) &&
                        (mes == 0 ||
                            (double.parse(
                                    provider.gastoActual.periodo.mes ?? '0') ==
                                0)) &&
                        (dia == 0 ||
                            (double.parse(
                                    provider.gastoActual.periodo.dia ?? '0') ==
                                0)))) {
                      showToast("Modifique algun campo de dia, mes o año");
                    } else {
                      await Dialogs.showMorph(
                          title: 'Guardar periodo',
                          description:
                              '¿Esta seguro de recordar periodicamente este tipo de gasto cada ${year != 0 ? "${widget.provider.convertirNumero(moneda: year)} año(s) " : ""}${mes != 0 ? "${widget.provider.convertirNumero(moneda: mes)} mes(es) " : ""}${dia != 0 ? "${widget.provider.convertirNumero(moneda: dia)} dias(s) " : ""}?',
                          loadingTitle: "Guardando",
                          onAcceptPressed: (context) async {
                            PeriodoModelo newPeriodo = PeriodoModelo(
                                year: year.toStringAsPrecision(4),
                                mes: mes.toStringAsPrecision(4),
                                dia: dia.toStringAsPrecision(4),
                                modificable: modificable ? 1 : 0);
                            final tempModel = provider.gastoActual
                                .copyWith(periodo: newPeriodo, peridico: 1);
                            provider.gastoActual = tempModel;
                            log("${provider.gastoActual.toJson()}");
                            Navigation.pop();
                          });
                    }
                  },
                  label: const Text("Guardar"),
                  icon: const Icon(Icons.save_alt))
            ])));
  }
}
