import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/models/metodo_pago_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DialogMetodoPagoCrear extends StatefulWidget {
  final MetodoPagoModel? metodo;
  const DialogMetodoPagoCrear({super.key, required this.metodo});

  @override
  State<DialogMetodoPagoCrear> createState() => _DialogMetodoPagoCrearState();
}

class _DialogMetodoPagoCrearState extends State<DialogMetodoPagoCrear> {
  TextEditingController nombre = TextEditingController();
  TextEditingController cambio = TextEditingController(text: "0");
  TextEditingController denominacion = TextEditingController();
  bool press = true;
  @override
  void initState() {
    super.initState();
    if (widget.metodo != null) {
      nombre.text = widget.metodo?.nombre ?? "";
      cambio.text = widget.metodo?.cambio.toString() ?? "0";
      denominacion.text = widget.metodo?.denominacion ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("${widget.metodo != null ? "Editar" : "Crear"} metodo de pago",
          style: TextStyle(fontSize: 16.sp)),
      Padding(
          padding: EdgeInsets.all(8.sp),
          child: Column(children: [
            TextField(
                enabled: press,
                textCapitalization: TextCapitalization.sentences,
                controller: nombre,
                decoration: InputDecoration(
                    label: Text("Nombre", style: TextStyle(fontSize: 16.sp)))),
            Divider(),
            TextField(
                enabled: press,
                controller: cambio,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                decoration: InputDecoration(
                    label: Text("Tipo de cambio",
                        style: TextStyle(fontSize: 16.sp)))),
            Divider(),
            TextField(
                enabled: press,
                textCapitalization: TextCapitalization.characters,
                controller: denominacion,
                decoration: InputDecoration(
                    label: Text("Denominacion",
                        style: TextStyle(fontSize: 16.sp)))),
            Divider(),
            Consumer<GastoProvider>(
                builder: (context, provider, child) => ElevatedButton(
                    onPressed: () async {
                      if (double.tryParse(cambio.text) != null) {
                        if (nombre.text != "" &&
                            cambio.text != "" &&
                            denominacion.text != "") {
                          setState(() {
                            press = false;
                          });

                          MetodoPagoModel metodoPago = MetodoPagoModel(
                              id: widget.metodo?.id ??
                                  await MetodoGastoController.lastId(),
                              nombre: nombre.text,
                              cambio: double.parse(cambio.text),
                              denominacion: denominacion.text,
                              status: 1,
                              defecto: 0);
                          print(await MetodoGastoController.lastId());
                          final result =
                              await MetodoGastoController.find(metodoPago);
                          if (result != null) {
                            log("Actualiza");
                            await MetodoGastoController.update(metodoPago);
                            showToast(
                                "El metodo ha sido actualizo de manera exitosa");
                          } else {
                            log("crea");
                            await MetodoGastoController.insert(metodoPago);
                            showToast(
                                "Se ha ingresado un nuevo metodo llamado ${metodoPago.nombre}");
                          }
                          provider.metodo =
                              await MetodoGastoController.getItems();
                          Navigation.pop();
                        } else {
                          showToast("Rellene todos los campos para continuar");
                        }
                      } else {
                        showToast(
                            "El tipo de cambio que ingreso no es un numero valido");
                      }
                    },
                    child: Text(widget.metodo != null ? "Editar" : "Crear",
                        style: TextStyle(fontSize: 16.sp))))
          ]))
    ]));
  }
}
