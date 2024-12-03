import 'dart:developer';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/dialog/dialog_foto_gasto.dart';
import 'package:gastos/dialog/dialog_periodo_gasto.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';
import '../dialog/dialog_camara.dart';
import 'package:badges/badges.dart' as badges;

import '../dialog/dialog_categorias.dart';
import '../models/categoria_model.dart';

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
    return SingleChildScrollView(
        child: Card(
            elevation: 2,
            child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Center(
                      child: Text(
                          "Fecha de ingreso\n${widget.provider.convertirFecha(fecha: widget.provider.selectFecha ?? now)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: LightThemeColors.darkGrey))),
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
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold)),
                                hintText: 'Tipo de Gasto',
                                items: widget.provider.listaCategoria,
                                itemsListPadding: const EdgeInsets.all(0),
                                listItemPadding: const EdgeInsets.all(0),
                                listItemBuilder: (context, item, isSelected,
                                        onItemSelect) =>
                                    ListTile(
                                        dense: true,
                                        title: Text(
                                            "${item.id}. ${item.nombre}",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(item.descripcion,
                                            style: TextStyle(fontSize: 14.sp)),
                                        trailing: IconButton(
                                            onPressed: () {
                                              Dialogs.showMorph(
                                                  title: "Eliminar",
                                                  description:
                                                      "¿Desea eliminar la cateogoria de gasto '${item.nombre}'? una vez eliminado aquellos gastos con esa categoria la perderan",
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
                                                    Navigation.pop();
                                                  });
                                            },
                                            icon: Icon(Icons.delete, size: 18.sp, color: LightThemeColors.red))),
                                overlayHeight: 40.h,
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
                                  builder: (context) =>
                                      const Dialog(child: DialogCategorias()));
                            },
                            icon: Icon(Icons.add,
                                size: 22.sp, color: Colors.white))
                      ]),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        onPressed: () async {
                          widget.provider.selectFecha = (await showDatePicker(
                                  context: context,
                                  initialDatePickerMode: DatePickerMode.day,
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                  initialDate: now,
                                  firstDate: now
                                      .subtract(const Duration(days: 365 * 15)),
                                  lastDate: now)) ??
                              now;
                          final modelTemp = widget.provider.gastoActual
                              .copyWith(
                                  fecha: widget.provider.convertirFechaHora(
                                      fecha:
                                          widget.provider.selectFecha ?? now),
                                  dia: (widget.provider.selectFecha?.day ??
                                          now.day)
                                      .toString(),
                                  mes: (widget.provider.selectFecha?.month ??
                                          now.month)
                                      .toString());
                          widget.provider.gastoActual = modelTemp;
                        },
                        icon: Icon(Icons.edit_calendar, size: 22.sp)),
                    SizedBox(
                        width: 35.w,
                        child: SpinBox(
                            min: .5,
                            max: 10000,
                            value: widget.provider.gastoActual.monto ?? 0,
                            decimals: 1,
                            acceleration: .5,
                            incrementIcon:
                                Icon(LineIcons.plusCircle, size: 24.sp),
                            decrementIcon:
                                Icon(LineIcons.minusCircle, size: 24.sp),
                            decoration: InputDecoration(
                                icon: Icon(Icons.attach_money, size: 22.sp)),
                            direction: Axis.vertical,
                            onSubmitted: (p0) {
                              final tempModel = widget.provider.gastoActual
                                  .copyWith(monto: p0);
                              widget.provider.gastoActual = tempModel;
                            },
                            onChanged: (value) {
                              final tempModel = widget.provider.gastoActual
                                  .copyWith(monto: value);
                              widget.provider.gastoActual = tempModel;
                            })),
                    OverflowBar(children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => const DialogCamara());
                          },
                          icon: Icon(Icons.add_photo_alternate,
                              size: 22.sp, color: LightThemeColors.green)),
                      badges.Badge(
                          showBadge: widget.provider.imagenesActual.isNotEmpty,
                          badgeContent:
                              Text("${widget.provider.imagenesActual.length}"),
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const DialogFotoGasto());
                              },
                              icon: Icon(Icons.photo_library,
                                  size: 22.sp,
                                  color: LightThemeColors.darkBlue)))
                    ])
                  ]),
                  if (kDebugMode)
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
                            icon: const Icon(Icons.calendar_month))),
                  const Divider(),
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
                          style: TextStyle(fontSize: 14.sp),
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
                          decoration: const InputDecoration(
                              hintText: "Notas de gasto")))
                ]))));
  }
}
