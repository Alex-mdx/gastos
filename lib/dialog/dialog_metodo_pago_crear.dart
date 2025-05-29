import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/models/metodo_pago_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
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
  TextEditingController cambio = TextEditingController(text: "1");
  TextEditingController denominacion = TextEditingController();
  Color coloreado = ThemaMain.primary;
  bool press = true;
  @override
  void initState() {
    super.initState();
    if (widget.metodo != null) {
      nombre.text = widget.metodo?.nombre ?? "";
      cambio.text = widget.metodo?.cambio.toString() ?? "1";
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
            TextButton.icon(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                Text('Elige un color',
                                    style: TextStyle(fontSize: 14.sp)),
                                SingleChildScrollView(
                                    child: ColorPicker(
                                        pickerColor: coloreado,
                                        onColorChanged: (value) =>
                                            coloreado = value))
                              ]))).whenComplete(() => setState(() {}));
                },
                label: Text("Seleccione un color",
                    style: TextStyle(fontSize: 15.sp)),
                icon: Icon(Icons.color_lens, color: coloreado, size: 24.sp)),
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
                              color: coloreado,
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
