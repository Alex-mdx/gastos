import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:animated_read_more_text/animated_read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/bidones_controller.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:gastos/models/metodo_pago_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/image_gen.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:gastos/widgets/generics/search_categorias.dart';
import 'package:gastos/widgets/generics/textfield_money.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../models/categoria_model.dart';
import '../utilities/services/navigation_services.dart';
import '../utilities/textos.dart';
import 'dialog_historial_pago_foto.dart';
import 'dialog_metodo_pago.dart';

class DialogHistorialPago extends StatefulWidget {
  final GastoModelo gasto;
  const DialogHistorialPago({super.key, required this.gasto});

  @override
  State<DialogHistorialPago> createState() => _DialogHistorialPagoState();
}

class _DialogHistorialPagoState extends State<DialogHistorialPago> {
  bool editar = false;
  late GastoModelo tempGasto;
  TextEditingController controller = TextEditingController();
  SingleSelectController<CategoriaModel> selects = SingleSelectController(null);
  MetodoPagoModel? metodoSelect;
  @override
  void initState() {
    super.initState();
  }

  Future<void> name() async {
    tempGasto = widget.gasto;
    controller.text = widget.gasto.monto.toString();
    var cate =
        await CategoriaController.getItem(id: tempGasto.categoriaId ?? -1);
    selects.value = cate;
    metodoSelect =
        await MetodoGastoController.getItem(id: tempGasto.metodoPagoId ?? -1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      AppBar(
          title: Text("Detalle de Registro",
              maxLines: 2, style: TextStyle(fontSize: 18.sp)),
          centerTitle: true,
          actions: [
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
                      await GastosController.deleteItem(widget.gasto.id!);

                      provider.listaGastos =
                          await GastosController.getConfigurado();
                      setState(() {
                        Navigation.pop();
                      });
                    }),
                icon: Icon(Icons.delete, color: ThemaMain.red, size: 20.sp))
          ]),
      Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Fecha: ${tempGasto.fecha}",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            Icon(Icons.timelapse, size: 18.sp, color: ThemaMain.green)
          ]),
      Container(
          constraints: BoxConstraints(maxHeight: 60.h),
          child: ListView(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 2.w),
              shrinkWrap: true,
              children: [
                cardMontos(
                    lCabeza: "Monto",
                    tipo: 1,
                    rCabeza: "\$${Textos.moneda(moneda: tempGasto.monto!)}",
                    lRelleno: provider.presupuesto?.activo == 0 ||
                            provider.presupuesto == null
                        ? ThemaMain.primary
                        : provider.porcentualColor(
                            provider.obtenerPorcentajeDia(
                                DateTime.parse(tempGasto.fecha!).weekday - 1,
                                tempGasto.monto!))),
                cardMontos(
                    lCabeza: "Categoria de gasto",
                    tipo: 2,
                    rCabeza: provider.listaCategoria
                            .firstWhereOrNull((element) =>
                                element.id == tempGasto.categoriaId)
                            ?.nombre ??
                        "Desconocido",
                    lRelleno: ThemaMain.primary),
                cardMontos(
                    lCabeza: "Metodo de gasto",
                    tipo: 3,
                    rCabeza:
                        "${provider.metodo.firstWhereOrNull((element) => element.id == tempGasto.metodoPagoId)?.nombre}",
                    lRelleno: ThemaMain.primary),
                FutureBuilder(
                    future: BidonesController.getItemByGasto(
                        gastoid: tempGasto.id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return cardMontos(
                            lCabeza: "Bidon",
                            tipo: 4,
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
                              tempGasto.nota == "" || tempGasto.nota == null
                                  ? "Sin notas"
                                  : tempGasto.nota.toString(),
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
                      tempGasto.evidencia.isEmpty
                          ? Text("Lista de Evidencias Vacias",
                              style: TextStyle(fontSize: 16.sp))
                          : Wrap(
                              children: tempGasto.evidencia.map((e) {
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
                                                idGasto: tempGasto.id!));
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
      required Color lRelleno,
      required int tipo,
      TextEditingController? controller,
      SingleSelectController<CategoriaModel>? singleSelect,
      Function(double)? monto,
      Function(CategoriaModel?)? fun,
      Function(CategoriaModel)? delete,
      Function(MetodoPagoModel)? metodo,
      MetodoPagoModel? metodoSelect}) {
    return Card(
        elevation: 0,
        child: Row(children: [
          Expanded(
              flex: 3,
              child: editar
                  ? tipo == 1
                      ? TextfieldMoney(
                          text: controller!, field: (p0) => monto!(p0))
                      : tipo == 2
                          ? SearchCategorias(
                              controller: singleSelect!,
                              list: [],
                              fun: (value) => fun!(value))
                          : TextButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => DialogMetodoPago(
                                      tipo: true,
                                      metodoSelect: metodoSelect,
                                      fun: (p0) {
                                        metodo!(p0);
                                      })),
                              child: Text(
                                  "Metodo de pago: ${metodoSelect?.nombre ?? "Sin metodo valido"}",
                                  style: TextStyle(
                                      color: ThemaMain.darkBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp)))
                  : Container(
                      decoration: BoxDecoration(
                          color: lRelleno,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10))),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.w, vertical: .5.h),
                          child: Text(lCabeza,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp))))),
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
