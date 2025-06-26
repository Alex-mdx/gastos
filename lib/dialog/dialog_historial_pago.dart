import 'package:animated_read_more_text/animated_read_more_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/image_gen.dart';
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
  double dia = 0;
  double mes = 0;
  double year = 0;
  bool modificable = false;
  bool expandible = false;
  @override
  void initState() {
    modificable = widget.gasto.periodo.modificable == 1 ? true : false;
    super.initState();
  }

  @override
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
                            await GastosController.getConfigurado();
                        setState(() {
                          Navigation.pop();
                        });
                      });
                },
                icon: Icon(Icons.delete,
                    color: ThemaMain.red, size: 20.sp))
          ]),
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Text("Fecha: ${widget.gasto.fecha}",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "${provider.metodo.firstWhereOrNull((element) => element.id == widget.gasto.metodoPagoId)?.nombre}: \$${Textos.moneda(moneda: widget.gasto.monto!)}",
                          style: TextStyle(fontSize: 15.sp)),
                      Text(
                          "Categoria: ${provider.listaCategoria.firstWhereOrNull((element) => element.id == widget.gasto.categoriaId)?.nombre ?? "Desconocido"}",
                          style: TextStyle(fontSize: 15.sp))
                    ]),
                AnimatedReadMoreText(
                    "Notas: ${widget.gasto.nota ?? "Sin notas"}",
                    maxLines: 2,
                    readMoreText: "...",
                    readLessText: ". menos",
                    buttonTextStyle: TextStyle(fontSize: 15.sp)),
                const Divider(),
                widget.gasto.evidencia.isEmpty
                    ? Text("Lista de Evidencias Vacias",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold))
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
                                      DialogHistorialPagoFoto(file: file, idGasto : widget.gasto.id!));
                            });
                      }).toList())
              ]))),
      if (kDebugMode) const Divider(),
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
}
