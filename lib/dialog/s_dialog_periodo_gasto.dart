import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DialogPeriodoGasto extends StatefulWidget {
  const DialogPeriodoGasto({super.key});

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
                              value: dia,
                              acceleration: 1,
                              direction: Axis.vertical,
                              onChanged: (value) => dia = year)),
                      Expanded(
                          child: SpinBox(
                              min: 0,
                              max: 11,
                              value: mes,
                              acceleration: 1,
                              direction: Axis.vertical,
                              onChanged: (value) => mes = value)),
                      Expanded(
                          child: SpinBox(
                              min: 0,
                              max: 10,
                              value: year,
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
                        ]))),
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    if ((year == 0 && mes == 0 && dia == 0)) {
                      showToast("Modifique algun campo de dia, mes o año");
                    } else {
                      await Dialogs.showMorph(
                          title: 'Guardar periodo',
                          description:
                              '¿Esta seguro de recordar periodicamente este tipo de gasto cada ${year != 0 ? "${provider.convertirNumero(moneda: year)} año(s)" : ""} ${mes != 0 ? "${provider.convertirNumero(moneda: mes)} mes(es)" : ""} ${dia != 0 ? "${provider.convertirNumero(moneda: dia)} dias(s)" : ""}?',
                          loadingTitle: "Guardando",
                          onAcceptPressed: (context) async {});
                    }
                  },
                  label: const Text("Guardar"),
                  icon: const Icon(Icons.save_alt))
            ])));
  }
}
