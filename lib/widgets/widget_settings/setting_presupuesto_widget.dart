import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/controllers/presupuesto_controller.dart';
import 'package:gastos/dialog/dialog_presupuesto_dia.dart';
import 'package:gastos/models/presupuesto_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';

class SettingPresupuestoWidget extends StatefulWidget {
  final GastoProvider provider;
  const SettingPresupuestoWidget({super.key, required this.provider});

  @override
  State<SettingPresupuestoWidget> createState() =>
      _SettingPresupuestoWidgetState();
}

class _SettingPresupuestoWidgetState extends State<SettingPresupuestoWidget>
    with TickerProviderStateMixin {
  late PresupuestoModel temporal;
  @override
  void initState() {
    super.initState();
    temporal = PresupuestoModel(
        activo: widget.provider.presupuesto?.activo ?? 0,
        presupuesto: widget.provider.presupuesto?.presupuesto ?? 0,
        lunes: widget.provider.presupuesto?.lunes ?? 0,
        martes: widget.provider.presupuesto?.martes ?? 0,
        miercoles: widget.provider.presupuesto?.miercoles ?? 0,
        jueves: widget.provider.presupuesto?.jueves ?? 0,
        viernes: widget.provider.presupuesto?.viernes ?? 0,
        sabado: widget.provider.presupuesto?.sabado ?? 0,
        domingo: widget.provider.presupuesto?.domingo ?? 0,
        periodo: widget.provider.presupuesto?.periodo);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Presupuesto",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      Padding(
          padding: EdgeInsets.all(8.sp),
          child: Row(children: [
            Expanded(
                flex: 4,
                child: SpinBox(
                    onChanged: (value) {
                      final newModel = temporal.copyWith(presupuesto: value);
                      setState(() {
                        widget.provider.presupuesto = newModel;
                      });
                      log("${widget.provider.presupuesto?.toJson()}");
                    },
                    min: 0,
                    textStyle: TextStyle(fontSize: 15.sp),
                    max: 1000000,
                    value: temporal.presupuesto!,
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: false),
                    decoration: InputDecoration(
                        fillColor: ThemaMain.white,
                        labelText: "Monto limite para esta semana"))),
            Expanded(
                flex: 1,
                child: IconButton.filled(
                    iconSize: 24.sp,
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) =>
                            DialogPresupuestoDia(provider: widget.provider)),
                    icon:
                        Icon(LineIcons.commentsDollar, color: ThemaMain.green)))
          ])),
      ElevatedButton.icon(
          icon: Icon(
              widget.provider.presupuesto?.activo == 1
                  ? Icons.money_off
                  : LineIcons.wallet,
              size: 20.sp),
          onPressed: () async {
            widget.provider.presupuesto?.activo == 1
                ? await Dialogs.showMorph(
                    title: "Desactivar Presupuestos",
                    description:
                        "Al desactivar los presupuestos simplemente ocasionara que no haya un apoyo visual al momento de controlar sus gastos",
                    loadingTitle: "Desactivando",
                    onAcceptPressed: (context) async {
                      await PresupuestoController.insert(
                          widget.provider.presupuesto!.copyWith(activo: 0));
                      widget.provider.presupuesto =
                          await PresupuestoController.getItem();
                      showToast("Presupuesto Desactivado");
                    })
                : await Dialogs.showMorph(
                    title: "Activar Presupuestos",
                    description:
                        "Al activar los presupuestos, pondra un limite visual al momento de hacer sus gastos cuando se sobre pase de su presupuesto ingresado, ya sea semanal o por un dia en especifico segun sea el monto\nIngrese montos de 0 si no quiere aplicar algun presupuesto\nNOTA: ESTO NO AFECTARA LA MANERA EN LA QUE INGRESA SUS GASTOS",
                    loadingTitle: "Activando",
                    onAcceptPressed: (context) async {
                      await PresupuestoController.insert(
                          widget.provider.presupuesto!.copyWith(activo: 1));
                      widget.provider.presupuesto =
                          await PresupuestoController.getItem();
                      showToast("Presupuesto activado");
                    });
          },
          label: Text(
              widget.provider.presupuesto?.activo == 1
                  ? "Desactivar"
                  : "Activar",
              style: TextStyle(fontSize: 16.sp))),
      ElevatedButton.icon(
          icon: Icon(LineIcons.eraser, size: 20.sp, color: ThemaMain.red),
          onPressed: () {
            Dialogs.showMorph(
                title: "Eliminar presupuesto",
                description:
                    "¿Desea eliminar sus presupuestos ingresados?\nEliminar sus presupuestos hara que se vacien todos su montos y por ende se desactive",
                loadingTitle: "Eliminando",
                onAcceptPressed: (context) async {
                  await PresupuestoController.deleteAll();
                  widget.provider.presupuesto =
                      await PresupuestoController.getItem();
                  showToast("Presupuesto Eliminado");
                  temporal = PresupuestoModel(
                      activo: widget.provider.presupuesto?.activo ?? 0,
                      presupuesto:
                          widget.provider.presupuesto?.presupuesto ?? 0,
                      lunes: widget.provider.presupuesto?.lunes ?? 0,
                      martes: widget.provider.presupuesto?.martes ?? 0,
                      miercoles: widget.provider.presupuesto?.miercoles ?? 0,
                      jueves: widget.provider.presupuesto?.jueves ?? 0,
                      viernes: widget.provider.presupuesto?.viernes ?? 0,
                      sabado: widget.provider.presupuesto?.sabado ?? 0,
                      domingo: widget.provider.presupuesto?.domingo ?? 0,
                      periodo: widget.provider.presupuesto?.periodo);
                });
          },
          label: Text("Eliminar presupuestos",
              style: TextStyle(fontSize: 16.sp, color: ThemaMain.red)))
    ]);
  }
}
