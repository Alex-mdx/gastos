import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/utilities/gasto_provider.dart';
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
        presupuesto: widget.provider.presupuesto?.presupuesto ?? 1,
        lunes: widget.provider.presupuesto?.lunes ?? 1,
        martes: widget.provider.presupuesto?.martes ?? 1,
        miercoles: widget.provider.presupuesto?.miercoles ?? 1,
        jueves: widget.provider.presupuesto?.jueves ?? 1,
        viernes: widget.provider.presupuesto?.viernes ?? 1,
        sabado: widget.provider.presupuesto?.sabado ?? 1,
        domingo: widget.provider.presupuesto?.domingo ?? 1,
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
              const Divider(),
              SingleChildScrollView(
                  child: Wrap(runSpacing: 1.h, spacing: 1.w, children: [
                SizedBox(
                    width: 36.w,
                    child: SpinBox(
                        onChanged: (value) {
                          final newModel = temporal.copyWith(lunes: value);
                          setState(() {
                            widget.provider.presupuesto = newModel;
                            temporal = newModel;
                          });
                          log("${widget.provider.presupuesto?.toJson()}");
                        },
                        min: 1,
                        max: 1000000,
                        value: temporal.lunes!,
                        textStyle: TextStyle(fontSize: 15.sp),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false),
                        decoration:
                            const InputDecoration(labelText: "Limite Lunes"))),
                SizedBox(
                    width: 36.w,
                    child: SpinBox(
                        onChanged: (value) {
                          final newModel = temporal.copyWith(martes: value);
                          setState(() {
                            widget.provider.presupuesto = newModel;
                            temporal = newModel;
                          });
                          log("${widget.provider.presupuesto?.toJson()}");
                        },
                        min: 1,
                        max: 1000000,
                        value: temporal.martes!,
                        textStyle: TextStyle(fontSize: 15.sp),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false),
                        decoration:
                            const InputDecoration(labelText: "Limite Martes"))),
                SizedBox(
                    width: 36.w,
                    child: SpinBox(
                        onChanged: (value) {
                          final newModel = temporal.copyWith(miercoles: value);
                          setState(() {
                            widget.provider.presupuesto = newModel;
                            temporal = newModel;
                          });
                          log("${widget.provider.presupuesto?.toJson()}");
                        },
                        min: 1,
                        max: 1000000,
                        value: temporal.miercoles!,
                        textStyle: TextStyle(fontSize: 15.sp),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false),
                        decoration: const InputDecoration(
                            labelText: "Limite Miercoles"))),
                SizedBox(
                    width: 36.w,
                    child: SpinBox(
                        onChanged: (value) {
                          final newModel = temporal.copyWith(jueves: value);
                          setState(() {
                            widget.provider.presupuesto = newModel;
                            temporal = newModel;
                          });
                          log("${widget.provider.presupuesto?.toJson()}");
                        },
                        min: 1,
                        max: 1000000,
                        value: temporal.jueves!,
                        textStyle: TextStyle(fontSize: 15.sp),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false),
                        decoration:
                            const InputDecoration(labelText: "Limite Jueves"))),
                SizedBox(
                    width: 36.w,
                    child: SpinBox(
                        onChanged: (value) {
                          final newModel = temporal.copyWith(viernes: value);
                          setState(() {
                            widget.provider.presupuesto = newModel;
                            temporal = newModel;
                          });
                          log("${widget.provider.presupuesto?.toJson()}");
                        },
                        min: 1,
                        max: 1000000,
                        value: temporal.viernes!,
                        textStyle: TextStyle(fontSize: 15.sp),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false),
                        decoration: const InputDecoration(
                            labelText: "Limite Viernes"))),
                SizedBox(
                    width: 36.w,
                    child: SpinBox(
                        onChanged: (value) {
                          final newModel = temporal.copyWith(sabado: value);
                          setState(() {
                            widget.provider.presupuesto = newModel;
                            temporal = newModel;
                          });
                          log("${widget.provider.presupuesto?.toJson()}");
                        },
                        min: 1,
                        max: 1000000,
                        value: temporal.sabado!,
                        textStyle: TextStyle(fontSize: 15.sp),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false),
                        decoration:
                            const InputDecoration(labelText: "Limite Sabado"))),
                SizedBox(
                    width: 36.w,
                    child: SpinBox(
                        onChanged: (value) {
                          final newModel = temporal.copyWith(domingo: value);
                          setState(() {
                            widget.provider.presupuesto = newModel;
                            temporal = newModel;
                          });
                          log("${widget.provider.presupuesto?.toJson()}");
                        },
                        min: 1,
                        max: 1000000,
                        value: temporal.domingo!,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false),
                        textStyle: TextStyle(fontSize: 15.sp),
                        decoration:
                            const InputDecoration(labelText: "Limite Domingo")))
              ]))
            ])));
  }
}
