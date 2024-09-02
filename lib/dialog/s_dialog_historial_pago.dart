import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DialogHistorialPago extends StatefulWidget {
  final GastoModelo gasto;
  const DialogHistorialPago({super.key, required this.gasto});

  @override
  State<DialogHistorialPago> createState() => _DialogHistorialPagoState();
}

class _DialogHistorialPagoState extends State<DialogHistorialPago> {
  @override
  double dia = 0;
  double mes = 0;
  double year = 0;
  bool modificable = false;
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      AppBar(
          title: Text("Historial Detalle", style: TextStyle(fontSize: 18.sp)),
          centerTitle: true,
          actions: [
            IconButton.filled(
                onPressed: () {
                  Dialogs.showMorph(
                      title: "Eliminar",
                      description:
                          "¿Desea eliminar esta tarjeta?, Eliminara los detalles y evidencias",
                      loadingTitle: "Eliminando",
                      onAcceptPressed: (context) async {
                        await GastosController.deleteItem(widget.gasto.id!);
                        provider.listaGastos =
                            await GastosController.getItems();
                      });
                },
                icon: Icon(Icons.delete,
                    color: LightThemeColors.red, size: 20.sp))
          ]),
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Monto: \$${provider.convertirNumero(moneda: widget.gasto.monto!)}",
                          style: TextStyle(fontSize: 16.sp)),
                      Text(
                          "Categoria: ${provider.listaCategoria.firstWhereOrNull((element) => element.id == widget.gasto.categoriaId)?.nombre ?? "Desconocido"}",
                          style: TextStyle(fontSize: 16.sp))
                    ]),
                Text("Fecha: ${widget.gasto.fecha}",
                    style: TextStyle(fontSize: 16.sp)),
                if (widget.gasto.peridico == 1)
                  Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Text("Gasto Peridico",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                            const Divider(),
                            SizedBox(
                                height: 25.h,
                                child: Row(children: [
                                  Expanded(
                                      child: SpinBox(
                                          min: 0,
                                          max: 30,
                                          decoration: const InputDecoration(
                                              helperText: "Dia"),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                              decimal: false, signed: false),
                                          enabled: widget.gasto.periodo
                                                      .modificable ==
                                                  1
                                              ? true
                                              : false,
                                          value: double.parse(
                                              widget.gasto.periodo.dia!),
                                          acceleration: 1,
                                          direction: Axis.vertical,
                                          onChanged: (value) => dia = value)),
                                  Expanded(
                                      child: SpinBox(
                                          min: 0,
                                          max: 11,
                                          decoration: const InputDecoration(
                                              helperText: "Mes"),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                              decimal: false, signed: false),
                                          enabled: widget.gasto.periodo
                                                      .modificable ==
                                                  1
                                              ? true
                                              : false,
                                          value: double.parse(
                                              widget.gasto.periodo.mes!),
                                          acceleration: 1,
                                          direction: Axis.vertical,
                                          onChanged: (value) => mes = value)),
                                  Expanded(
                                      child: SpinBox(
                                          min: 0,
                                          max: 10,
                                          decoration: const InputDecoration(
                                              helperText: "Año"),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                              decimal: false, signed: false),
                                          enabled: widget.gasto.periodo
                                                      .modificable ==
                                                  1
                                              ? true
                                              : false,
                                          value: double.parse(
                                              widget.gasto.periodo.year!),
                                          acceleration: 1,
                                          direction: Axis.vertical,
                                          onChanged: (value) => year = value))
                                ])),
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
                                        ]))))
                          ]))),
                const Divider(),
                widget.gasto.evidencia.isEmpty
                    ? Text("Lista de Evidencias Vacias",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold))
                    : Wrap(
                        children: widget.gasto.evidencia.map(
                        (e) {
                          return Icon(Icons.photo, size: 20.sp);
                        },
                      ).toList())
              ]))),
      const Divider(),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton.filledTonal(
              onPressed: () {
                Dialogs.showMorph(
                    title: "Guardar cambios",
                    description:
                        "¿Desea guardar los cambios realizados en esta tarjeta de gasto?",
                    loadingTitle: "Actualizando",
                    onAcceptPressed: (context) async {
                      /* final newModel = gasto.periodo. */
                    });
              },
              icon: const Icon(Icons.save)))
    ]));
  }
}
