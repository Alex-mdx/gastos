import 'dart:developer';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/dialog/dialog_metodo_pago.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:gastos/widgets/gasto_send_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';
import '../dialog/dialog_camara.dart';
import 'package:badges/badges.dart' as badges;
import '../dialog/dialog_categorias.dart';
import '../models/categoria_model.dart';

class CardGastoWidget extends StatefulWidget {
  final GastoProvider provider;
  final GlobalKey gastoKey;
  const CardGastoWidget(
      {super.key, required this.provider, required this.gastoKey});

  @override
  State<CardGastoWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CardGastoWidget> {
  DateTime now = DateTime.now();
  SingleSelectController<CategoriaModel> controller =
      SingleSelectController(null);
  @override
  void initState() {
    super.initState();
  }

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
                            },
                            icon: Icon(Icons.edit_calendar,
                                size: 22.sp, color: ThemaMain.darkBlue),
                            label: Text(
                                "Fecha de ingreso\n${Textos.fechaYMD(fecha: widget.provider.selectFecha ?? now)}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ThemaMain.darkBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp)))),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                              width: 65.w,
                              child: CustomDropdown.searchRequest(
                                  futureRequest: (p0) async =>
                                      await CategoriaController.buscar(p0),
                                  searchHintText: "Nombre categoria de gasto",
                                  noResultFoundText: "Sin resultados",
                                  controller: controller,
                                  closedHeaderPadding: EdgeInsets.symmetric(
                                      horizontal: 1.w, vertical: 0),
                                  decoration: CustomDropdownDecoration(
                                      expandedFillColor: ThemaMain.background,
                                      closedFillColor: ThemaMain.background,
                                      prefixIcon: Icon(LineIcons.wavyMoneyBill,
                                          color: ThemaMain.green, size: 22.sp),
                                      searchFieldDecoration:
                                          SearchFieldDecoration(
                                              fillColor:
                                                  ThemaMain.dialogbackground),
                                      closedSuffixIcon: controller.value != null
                                          ? IconButton(
                                              iconSize: 20.sp,
                                              onPressed: () => setState(() {
                                                    controller.clear();
                                                  }),
                                              icon: Icon(Icons.close_rounded,
                                                  color: ThemaMain.red,
                                                  size: 20.sp))
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.h),
                                              child: Icon(
                                                  Icons
                                                      .keyboard_double_arrow_down,
                                                  color: ThemaMain.primary,
                                                  size: 20.sp))),
                                  headerBuilder:
                                      (context, selectedItem, enabled) => Text(
                                          selectedItem.nombre,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: ThemaMain.darkGrey,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold)),
                                  hintText: 'Categoria de Gasto',
                                  items: widget.provider.listaCategoria,
                                  itemsListPadding: const EdgeInsets.all(0),
                                  listItemPadding: const EdgeInsets.all(0),
                                  listItemBuilder: (context, item, isSelected, onItemSelect) => ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0),
                                      title: Text(item.nombre, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: ThemaMain.darkBlue, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                                      subtitle: Text(item.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: ThemaMain.darkGrey, fontSize: 13.sp)),
                                      trailing: IconButton(
                                          onPressed: () => Dialogs.showMorph(
                                              title: "Eliminar",
                                              description: "¿Desea eliminar la categoria de gasto '${item.nombre}'? una vez eliminado aquellos gastos con esa categoria la perderan",
                                              loadingTitle: "Eliminando",
                                              onAcceptPressed: (context) async {
                                                await CategoriaController
                                                    .deleteItem(item.id!);
                                                final data =
                                                    await CategoriaController
                                                        .getItems();
                                                setState(() {
                                                  controller.clear();
                                                  widget.provider
                                                      .listaCategoria = data;
                                                });
                                              }),
                                          icon: Icon(Icons.delete, size: 16.sp, color: ThemaMain.red))),
                                  overlayHeight: 52.h,
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
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const Dialog(child: DialogCategorias())),
                              icon:
                                  Stack(alignment: Alignment.center, children: [
                                Icon(LineIcons.wavyMoneyBill,
                                    color: Colors.white, size: 20.sp),
                                Icon(Icons.add,
                                    size: 22.sp, color: Colors.white)
                              ]))
                        ]),
                    OverflowBar(
                        overflowAlignment: OverflowBarAlignment.center,
                        alignment: MainAxisAlignment.spaceAround,
                        children: [
                          badges.Badge(
                              badgeStyle: badges.BadgeStyle(
                                  badgeColor: ThemaMain.primary),
                              showBadge:
                                  widget.provider.imagenesActual.isNotEmpty,
                              badgeContent: Text(
                                  "${widget.provider.imagenesActual.length}",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: ThemaMain.white)),
                              child: IconButton.filled(
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const DialogCamara()),
                                  icon: Icon(Icons.add_photo_alternate,
                                      size: 22.sp, color: Colors.white))),
                          SizedBox(
                              width: 45.w,
                              child: SpinBox(
                                  min: 0,
                                  max: 999999,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: false),
                                  value: widget.provider.gastoActual.monto ?? 0,
                                  decimals: 2,
                                  textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      color: ThemaMain.darkBlue),
                                  incrementIcon:
                                      Icon(LineIcons.plusCircle, size: 22.sp),
                                  decrementIcon:
                                      Icon(LineIcons.minusCircle, size: 22.sp),
                                  decoration: InputDecoration(
                                      fillColor: ThemaMain.background,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 1.h),
                                      icon: Icon(Icons.attach_money,
                                          size: 20.sp, color: ThemaMain.green)),
                                  direction: Axis.vertical,
                                  step: 1,
                                  autofocus: false,
                                  interval: Durations.long1,
                                  spacing: 0,
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
                                  }))
                        ]),
                    TextButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) => DialogMetodoPago(tipo: true)),
                        child: Text(
                            "Metodo de pago: ${widget.provider.metodoSelect?.nombre ?? "Sin metodo valido"}",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: ThemaMain.darkBlue))),
                    SizedBox(
                        height: 6.h,
                        child: TextField(
                            onTapOutside: (event) {
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            autofocus: false,
                            expands: true,
                            maxLines: null,
                            style: TextStyle(
                                fontSize: 15.sp, color: ThemaMain.darkGrey),
                            controller: widget.provider.notas,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: ThemaMain.grey),
                                fillColor: ThemaMain.background,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: .5.h, horizontal: 2.w),
                                hintText: "Notas de gasto")))
                  ])))),
      GastoSendWidget(gastoKey: widget.gastoKey)
    ]);
  }
}
