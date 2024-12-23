import 'dart:developer';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/dialog/dialog_foto_gasto.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';
import '../controllers/gastos_controller.dart';
import '../dialog/dialog_camara.dart';
import 'package:badges/badges.dart' as badges;

import '../dialog/dialog_categorias.dart';
import '../models/categoria_model.dart';
import '../models/gasto_model.dart';
import '../models/periodo_model.dart';

class CardGastoWidget extends StatefulWidget {
  final GastoProvider provider;
  const CardGastoWidget({super.key, required this.provider});

  @override
  State<CardGastoWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CardGastoWidget> {
  DateTime now = DateTime.now();
  SingleSelectController<CategoriaModel> controller =
      SingleSelectController(null);

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SingleChildScrollView(
          child: Card(
              elevation: 2,
              child: Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Center(
                        child: TextButton.icon(
                            style: ButtonStyle(
                                elevation: WidgetStatePropertyAll(1)),
                            onPressed: () async {
                              widget
                                  .provider.selectFecha = (await showDatePicker(
                                      context: context,
                                      initialDatePickerMode: DatePickerMode.day,
                                      initialEntryMode:
                                          DatePickerEntryMode.calendarOnly,
                                      initialDate: now,
                                      firstDate: now.subtract(
                                          const Duration(days: 365 * 15)),
                                      lastDate: now)) ??
                                  now;
                              final modelTemp = widget.provider.gastoActual
                                  .copyWith(
                                      fecha: widget.provider.convertirFechaHora(
                                          fecha: widget.provider.selectFecha ??
                                              now),
                                      dia: (widget.provider.selectFecha?.day ??
                                              now.day)
                                          .toString(),
                                      mes:
                                          (widget.provider.selectFecha?.month ??
                                                  now.month)
                                              .toString());
                              widget.provider.gastoActual = modelTemp;
                            },
                            icon: Icon(Icons.edit_calendar, size: 22.sp),
                            label: Text(
                                "Fecha de ingreso\n${widget.provider.convertirFecha(fecha: widget.provider.selectFecha ?? now)}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp)))),
                    const Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                              width: 70.w,
                              child: CustomDropdown.searchRequest(
                                  futureRequest: (p0) async =>
                                      await CategoriaController.buscar(p0),
                                  searchHintText: "Nombre categoria de gasto",
                                  noResultFoundText: "Sin resultados",
                                  controller: controller,
                                  decoration: CustomDropdownDecoration(
                                      prefixIcon: Icon(LineIcons.wavyMoneyBill,
                                          color: LightThemeColors.green,
                                          size: 22.sp),
                                      closedSuffixIcon: controller.value != null
                                          ? IconButton(
                                              iconSize: 22.sp,
                                              onPressed: () => setState(() {
                                                    controller.clear();
                                                  }),
                                              icon: Icon(Icons.close_rounded,
                                                  size: 20.sp))
                                          : null),
                                  headerBuilder:
                                      (context, selectedItem, enabled) => Text(
                                          selectedItem.nombre,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold)),
                                  hintText: 'Categoria de Gasto',
                                  items: widget.provider.listaCategoria,
                                  itemsListPadding: const EdgeInsets.all(0),
                                  listItemPadding: const EdgeInsets.all(0),
                                  listItemBuilder: (context, item, isSelected,
                                          onItemSelect) =>
                                      ListTile(
                                          dense: true,
                                          title: Text(item.nombre,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold)),
                                          subtitle: Text(item.descripcion,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  TextStyle(fontSize: 14.sp)),
                                          trailing: IconButton(
                                              onPressed: () {
                                                Dialogs.showMorph(
                                                    title: "Eliminar",
                                                    description:
                                                        "¿Desea eliminar la categoria de gasto '${item.nombre}'? una vez eliminado aquellos gastos con esa categoria la perderan",
                                                    loadingTitle: "Eliminando",
                                                    onAcceptPressed:
                                                        (context) async {
                                                      await CategoriaController
                                                          .deleteItem(item.id!);
                                                      final data =
                                                          await CategoriaController
                                                              .getItems();
                                                      setState(() {
                                                        controller.clear();
                                                        widget.provider
                                                                .listaCategoria =
                                                            data;
                                                      });
                                                    });
                                              },
                                              icon: Icon(Icons.delete, size: 18.sp, color: LightThemeColors.red))),
                                  overlayHeight: 50.h,
                                  onChanged: (value) {
                                    if (value != null) {
                                      log("$value");
                                      final modelTemp = widget
                                          .provider.gastoActual
                                          .copyWith(categoriaId: value.id);
                                      widget.provider.gastoActual = modelTemp;
                                      log("${widget.provider.gastoActual.toJson()}");
                                    }
                                  })),
                          IconButton.filled(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => const Dialog(
                                        child: DialogCategorias()));
                              },
                              icon: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Icon(LineIcons.wavyMoneyBill,
                                        color: Colors.white, size: 22.sp),
                                    Icon(Icons.add,
                                        size: 22.sp, color: Colors.white)
                                  ]))
                        ]),
                    OverflowBar(
                        overflowAlignment: OverflowBarAlignment.center,
                        alignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton.filled(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => const DialogCamara());
                              },
                              icon: Icon(Icons.add_photo_alternate,
                                  size: 22.sp, color: Colors.white)),
                          SizedBox(
                              width: 45.w,
                              child: SpinBox(
                                  min: .5,
                                  max: 10000,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: false),
                                  value: widget.provider.gastoActual.monto ?? 0,
                                  decimals: 1,
                                  textStyle: TextStyle(fontSize: 16.sp),
                                  incrementIcon:
                                      Icon(LineIcons.plusCircle, size: 22.sp),
                                  decrementIcon:
                                      Icon(LineIcons.minusCircle, size: 22.sp),
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.attach_money,
                                          size: 20.sp,
                                          color: LightThemeColors.green)),
                                  direction: Axis.vertical,
                                  onSubmitted: (p0) {
                                    final tempModel = widget
                                        .provider.gastoActual
                                        .copyWith(monto: p0);
                                    widget.provider.gastoActual = tempModel;
                                  },
                                  onChanged: (value) {
                                    final tempModel = widget
                                        .provider.gastoActual
                                        .copyWith(monto: value);
                                    widget.provider.gastoActual = tempModel;
                                  })),
                          badges.Badge(
                              showBadge:
                                  widget.provider.imagenesActual.isNotEmpty,
                              badgeContent: Text(
                                  "${widget.provider.imagenesActual.length}"),
                              child: IconButton.filled(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const DialogFotoGasto());
                                  },
                                  icon: Icon(LineIcons.imageFile,
                                      size: 22.sp, color: Colors.white)))
                        ]),
                    /* if (kDebugMode)
                        Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => DialogPeriodoGasto(
                                          provider: widget.provider));
                                },
                                label: Text('Gasto Cronologico',
                                    style: TextStyle(fontSize: 15.sp)),
                                icon: const Icon(Icons.calendar_month))), */
                    SizedBox(
                        height: 7.h,
                        child: TextField(
                            onTapOutside: (event) {
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            autofocus: false,
                            expands: true,
                            maxLines: null,
                            style: TextStyle(fontSize: 15.sp),
                            controller: widget.provider.notas,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              final tempModel = widget.provider.gastoActual
                                  .copyWith(nota: widget.provider.notas.text);
                              widget.provider.gastoActual = tempModel;
                            },
                            onSubmitted: (value) {
                              log("${widget.provider.gastoActual.toJson()}");
                            },
                            decoration:
                                InputDecoration(hintText: "Notas de gasto")))
                  ])))),
      SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(LightThemeColors.green)),
              onPressed: () async {
                if (widget.provider.gastoActual.categoriaId != null) {
                  if (widget.provider.gastoActual.monto != null &&
                      widget.provider.gastoActual.monto! > 0.0) {
                    log("${widget.provider.gastoActual.toJson()}");
                    await Dialogs.showMorph(
                        title: "Ingresar gasto",
                        description: "¿Desea ingresar esta tarjeta de gasto?",
                        loadingTitle: "Ingresando...",
                        onAcceptPressed: (context) async {
                          final now = DateTime.now();
                          //?La tabla de gasto es para notificar si dicha tarjeta es modificable
                          var id = (await GastosController.getLastId()) ?? 1;
                          log("${id + 1}");
                          final finalTemp = widget.provider.gastoActual
                              .copyWith(
                                  id: id + 1,
                                  gasto: 1,
                                  ultimaFecha: widget.provider.selectProxima ==
                                          null
                                      ? null
                                      : widget.provider.convertirFecha(
                                          fecha:
                                              widget.provider.selectProxima!),
                                  fecha: widget.provider.gastoActual.fecha ??
                                      widget.provider
                                          .convertirFechaHora(fecha: now),
                                  dia: widget.provider.gastoActual.dia ??
                                      (now.day).toString(),
                                  mes: widget.provider.gastoActual.mes ??
                                      (now.month).toString());
                          log("${finalTemp.toJson()}");
                          await GastosController.insert(finalTemp);
                          widget.provider.listaGastos =
                              await GastosController.getConfigurado();
                          widget.provider.selectProxima =
                              widget.provider.selectProxima;
                          widget.provider.gastoActual = GastoModelo(
                              id: null,
                              monto: null,
                              categoriaId: finalTemp.categoriaId,
                              fecha: null,
                              dia: null,
                              mes: null,
                              peridico: null,
                              ultimaFecha: null,
                              periodo: PeriodoModelo(
                                  year: null,
                                  mes: null,
                                  dia: null,
                                  modificable: null),
                              gasto: null,
                              evidencia: [],
                              nota: null);
                          //Limpia de variables locales
                          widget.provider.imagenesActual = [];
                          widget.provider.notas.clear();
                          widget.provider.selectFecha = DateTime.now();
                          showToast("Tarjeta de gasto Guardada con exito");
                        });
                  } else {
                    showToast("ingrese un monto mayor a 0");
                  }
                } else {
                  showToast("Ingrese una categoria de gasto");
                }
              },
              icon:
                  Icon(Icons.savings_rounded, size: 22.sp, color: Colors.white),
              label: Text("Guardar Gasto",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))))
    ]);
  }
}
