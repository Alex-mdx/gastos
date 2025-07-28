import 'package:animated_read_more_text/animated_read_more_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/bidones_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/image_gen.dart';
import 'package:gastos/utilities/operacion_bidon.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../utilities/services/navigation_services.dart';
import '../utilities/textos.dart';
import 'dialog_historial_pago_foto.dart';

class DialogHistorialPago extends StatefulWidget {
  final GastoModelo gasto;
  const DialogHistorialPago({super.key, required this.gasto});

  @override
  State<DialogHistorialPago> createState() => _DialogHistorialPagoState();
}

class _DialogHistorialPagoState extends State<DialogHistorialPago> {
  bool editar = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      AppBar(
          title: Text("Detalle del Registro",
              maxLines: 2, style: TextStyle(fontSize: 18.sp)),
          centerTitle: true,
          actions: [
            if (kDebugMode)
              IconButton(
                  onPressed: () => setState(() {
                        editar = !editar;
                      }),
                  icon: Icon(Icons.edit,
                      color: editar ? ThemaMain.green : ThemaMain.black,
                      size: 20.sp)),
            IconButton(
                onPressed: () => Dialogs.showMorph(
                    title: "Eliminar",
                    description:
                        "¿Desea eliminar esta tarjeta?, Eliminara los detalles y evidencias",
                    loadingTitle: "Eliminando",
                    onAcceptPressed: (context) async {
                      var temp = await BidonesController.getItemByGasto(
                          gastoid: widget.gasto.id!);
                      await GastosController.deleteItem(widget.gasto.id!);
                      if (temp != null) {
                        await OperacionGasto.actualizar(id: temp.id!);
                      }

                      provider.listaGastos =
                          await GastosController.getConfigurado();
                      setState(() {
                        Navigation.pop();
                      });
                    }),
                icon: Icon(Icons.delete, color: ThemaMain.red, size: 20.sp))
          ]),
      Text("Fecha: ${widget.gasto.fecha}",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
      Container(
          constraints: BoxConstraints(maxHeight: 60.h),
          child: ListView(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2.w),
              shrinkWrap: true,
              children: [
                cardMontos(
                    lCabeza: "Monto",
                    rCabeza: "\$${Textos.moneda(moneda: widget.gasto.monto!)}",
                    lRelleno: provider.presupuesto?.activo == 0 ||
                            provider.presupuesto == null
                        ? ThemaMain.primary
                        : provider.porcentualColor(
                            provider.obtenerPorcentajeDia(
                                DateTime.parse(widget.gasto.fecha!).weekday - 1,
                                widget.gasto.monto!))),
                cardMontos(
                    lCabeza: "Categoria de gasto",
                    rCabeza: provider.listaCategoria
                            .firstWhereOrNull((element) =>
                                element.id == widget.gasto.categoriaId)
                            ?.nombre ??
                        "Desconocido",
                    lRelleno: ThemaMain.primary),
                cardMontos(
                    lCabeza: "Metodo de gasto",
                    rCabeza:
                        "${provider.metodo.firstWhereOrNull((element) => element.id == widget.gasto.metodoPagoId)?.nombre}",
                    lRelleno: ThemaMain.primary),
                FutureBuilder(
                    future: BidonesController.getItemByGasto(
                        gastoid: widget.gasto.id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return cardMontos(
                            lCabeza: "Bidon",
                            rCabeza: snapshot.data?.nombre ?? "Sin nombre",
                            lRelleno: ThemaMain.darkGrey);
                      } else {
                        return Stack();
                      }
                    }),
                Card(
                    elevation: 0,
                    child: Column(children: [
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: ThemaMain.primary,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10))),
                          child: Padding(
                              padding: EdgeInsets.all(6.sp),
                              child: Text("Notas",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp)))),
                      Padding(
                          padding: EdgeInsets.all(6.sp),
                          child: AnimatedReadMoreText(
                              widget.gasto.nota == "" ||
                                      widget.gasto.nota == null
                                  ? "Sin notas"
                                  : widget.gasto.nota.toString(),
                              textStyle: TextStyle(fontSize: 15.sp),
                              maxLines: 3,
                              readMoreText: "...",
                              readLessText: ". menos",
                              buttonTextStyle: TextStyle(fontSize: 15.sp)))
                    ])),
                const Divider(),
                Card(
                    elevation: 0,
                    child: Column(children: [
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: ThemaMain.green,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10))),
                          child: Padding(
                              padding: EdgeInsets.all(6.sp),
                              child: Text("Evidencia Adjunta",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp)))),
                      widget.gasto.evidencia.isEmpty
                          ? Text("Lista de Evidencias Vacias",
                              style: TextStyle(fontSize: 16.sp))
                          : Wrap(
                              children: widget.gasto.evidencia.map((e) {
                              return IconButton(
                                  icon: Icon(Icons.photo, size: 20.sp),
                                  onPressed: () async {
                                    debugPrint(e);
                                    var file = await ImageGen.find(e);
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            DialogHistorialPagoFoto(
                                                file: file,
                                                idGasto: widget.gasto.id!));
                                  });
                            }).toList())
                    ]))
              ])),
      if (editar)
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
                icon: Icon(Icons.save, size: 24.sp)))
    ]));
  }

  Card cardMontos(
      {required String lCabeza,
      required String rCabeza,
      required Color lRelleno}) {
    return Card(
        elevation: 0,
        child: Row(children: [
          Expanded(
              flex: 3,
              child: Container(
                  decoration: BoxDecoration(
                      color: lRelleno,
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(10))),
                  child: Padding(
                      padding: EdgeInsets.all(6.sp),
                      child: Text(lCabeza,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.sp))))),
          Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.all(6.sp),
                  child: Text(rCabeza,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp))))
        ]));
  }
}
