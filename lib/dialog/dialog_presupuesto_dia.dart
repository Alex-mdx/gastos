import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:sizer/sizer.dart';

import '../models/presupuesto_model.dart';

class DialogPresupuestoDia extends StatefulWidget {
  final GastoProvider provider;
  const DialogPresupuestoDia({super.key, required this.provider});

  @override
  State<DialogPresupuestoDia> createState() => _DialogPresupuestoDiaState();
}

class _DialogPresupuestoDiaState extends State<DialogPresupuestoDia> {
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
    return Dialog(
        child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Ingrese su limite por dia",
                  style: TextStyle(fontSize: 16.sp)),
              OverflowBar(
                  overflowAlignment: OverflowBarAlignment.center,
                  alignment: MainAxisAlignment.center,
                  children: [
                    if (temporal.presupuesto! > 0)
                      ElevatedButton.icon(
                          onPressed: () {
                            var dia = temporal.presupuesto! / 7;
                            final newModel = temporal.copyWith(
                                lunes: dia,
                                martes: dia,
                                miercoles: dia,
                                jueves: dia,
                                viernes: dia,
                                sabado: dia,
                                domingo: dia);
                            setState(() {
                              widget.provider.presupuesto = newModel;
                              temporal = newModel;
                            });
                          },
                          label: Text("Particionar presupuesto por dia",
                              style: TextStyle(fontSize: 15.sp)),
                          icon: Icon(Icons.calendar_view_month, size: 20.sp)),
                    IconButton(
                        iconSize: 20.sp,
                        onPressed: () {
                          Dialogs.showMorph(
                              title: "Limpiar limites por dia",
                              description:
                                  "Limpiara los montos limites que ha ingresado por dia",
                              loadingTitle: "Eliminado",
                              onAcceptPressed: (context) async {
                                final newModel = temporal.copyWith(
                                    lunes: 0,
                                    martes: 0,
                                    miercoles: 0,
                                    jueves: 0,
                                    viernes: 0,
                                    sabado: 0,
                                    domingo: 0);
                                setState(() {
                                  widget.provider.presupuesto = newModel;
                                  temporal = newModel;
                                });
                              });
                        },
                        icon: Icon(Icons.cleaning_services,
                            color: LightThemeColors.darkBlue))
                  ]),
              const Divider(),
              SingleChildScrollView(
                  child: Wrap(
                      alignment: WrapAlignment.spaceAround,
                      runSpacing: 1.h,
                      spacing: 1.w,
                      children: [
                    SizedBox(
                        width: 40.w,
                        child: SpinBox(
                            onChanged: (value) {
                              final newModel = temporal.copyWith(lunes: value);
                              setState(() {
                                widget.provider.presupuesto = newModel;
                                temporal = newModel;
                              });
                              log("${widget.provider.presupuesto?.toJson()}");
                            },
                            min: 0,
                            max: 1000000,
                            decimals: 1,
                            value: temporal.lunes!,
                            textStyle: TextStyle(fontSize: 15.sp),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: false),
                            decoration: const InputDecoration(
                                labelText: "Limite Lunes"))),
                    SizedBox(
                        width: 40.w,
                        child: SpinBox(
                            onChanged: (value) {
                              final newModel = temporal.copyWith(martes: value);
                              setState(() {
                                widget.provider.presupuesto = newModel;
                                temporal = newModel;
                              });
                              log("${widget.provider.presupuesto?.toJson()}");
                            },
                            min: 0,
                            max: 1000000,
                            decimals: 1,
                            value: temporal.martes!,
                            textStyle: TextStyle(fontSize: 15.sp),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: false),
                            decoration: const InputDecoration(
                                labelText: "Limite Martes"))),
                    SizedBox(
                        width: 40.w,
                        child: SpinBox(
                            onChanged: (value) {
                              final newModel =
                                  temporal.copyWith(miercoles: value);
                              setState(() {
                                widget.provider.presupuesto = newModel;
                                temporal = newModel;
                              });
                              log("${widget.provider.presupuesto?.toJson()}");
                            },
                            min: 0,
                            max: 1000000,
                            decimals: 1,
                            value: temporal.miercoles!,
                            textStyle: TextStyle(fontSize: 15.sp),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: false),
                            decoration: const InputDecoration(
                                labelText: "Limite Miercoles"))),
                    SizedBox(
                        width: 40.w,
                        child: SpinBox(
                            onChanged: (value) {
                              final newModel = temporal.copyWith(jueves: value);
                              setState(() {
                                widget.provider.presupuesto = newModel;
                                temporal = newModel;
                              });
                              log("${widget.provider.presupuesto?.toJson()}");
                            },
                            min: 0,
                            max: 1000000,
                            decimals: 1,
                            value: temporal.jueves!,
                            textStyle: TextStyle(fontSize: 15.sp),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: false),
                            decoration: const InputDecoration(
                                labelText: "Limite Jueves"))),
                    SizedBox(
                        width: 40.w,
                        child: SpinBox(
                            onChanged: (value) {
                              final newModel =
                                  temporal.copyWith(viernes: value);
                              setState(() {
                                widget.provider.presupuesto = newModel;
                                temporal = newModel;
                              });
                              log("${widget.provider.presupuesto?.toJson()}");
                            },
                            min: 0,
                            max: 1000000,
                            decimals: 1,
                            value: temporal.viernes!,
                            textStyle: TextStyle(fontSize: 15.sp),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: false),
                            decoration: const InputDecoration(
                                labelText: "Limite Viernes"))),
                    SizedBox(
                        width: 40.w,
                        child: SpinBox(
                            onChanged: (value) {
                              final newModel = temporal.copyWith(sabado: value);
                              setState(() {
                                widget.provider.presupuesto = newModel;
                                temporal = newModel;
                              });
                              log("${widget.provider.presupuesto?.toJson()}");
                            },
                            min: 0,
                            max: 1000000,
                            decimals: 1,
                            value: temporal.sabado!,
                            textStyle: TextStyle(fontSize: 15.sp),
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: false),
                            decoration: const InputDecoration(
                                labelText: "Limite Sabado"))),
                    SizedBox(
                        width: 40.w,
                        child: SpinBox(
                            onChanged: (value) {
                              final newModel =
                                  temporal.copyWith(domingo: value);
                              setState(() {
                                widget.provider.presupuesto = newModel;
                                temporal = newModel;
                              });
                              log("${widget.provider.presupuesto?.toJson()}");
                            },
                            min: 0,
                            max: 1000000,
                            decimals: 1,
                            value: temporal.domingo!,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: false),
                            textStyle: TextStyle(fontSize: 15.sp),
                            decoration: const InputDecoration(
                                labelText: "Limite Domingo")))
                  ]))
            ])));
  }
}
