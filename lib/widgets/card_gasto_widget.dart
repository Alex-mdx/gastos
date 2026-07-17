import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gastos/widgets/generics/search_categorias.dart';
import 'package:gastos/widgets/generics/textfield_money.dart';
import 'package:intl/intl.dart';
import 'package:gastos/dialog/dialog_metodo_pago.dart';
import 'package:gastos/utilities/gasto_provider.dart';
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
  late TextEditingController montoController;

  @override
  void initState() {
    super.initState();
    double initialMonto = widget.provider.gastoActual.monto ?? 0.0;
    montoController = TextEditingController(
        text: initialMonto > 0
            ? NumberFormat.currency(
                    locale: 'en_US', symbol: '', decimalDigits: 2)
                .format(initialMonto)
            : '');
  }

  @override
  void dispose() {
    montoController.dispose();
    super.dispose();
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
                              var temp = (await showDatePicker(
                                      context: context,
                                      initialDatePickerMode: DatePickerMode.day,
                                      initialEntryMode:
                                          DatePickerEntryMode.calendarOnly,
                                      initialDate:
                                          widget.provider.selectFecha ?? now,
                                      currentDate: now,
                                      firstDate: now.subtract(
                                          const Duration(days: 365 * 15)),
                                      lastDate: now)) ??
                                  now;
                              setState(() {
                                widget.provider.selectFecha = temp;
                              });
                            },
                            icon: Icon(Icons.edit_calendar,
                                size: 22.sp, color: ThemaMain.darkBlue),
                            label: Text(
                                "Fecha de ingreso\n${Textos.fechaYMD(fecha: widget.provider.selectFecha ?? now)} - ${Textos.conversionDiaNombre(widget.provider.selectFecha ?? now, now)}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ThemaMain.darkBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp)))),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                              width: 75.w,
                              child: SearchCategorias(
                                controller: controller,
                                list: widget.provider.listaCategoria,
                                fun: (p0) {
                                  final modelTemp =
                widget.provider.gastoActual.copyWith(categoriaId: p0.id);

            widget.provider.gastoActual = modelTemp;
                                },
                                delete: (p0) =>
                                  widget.provider.listaCategoria = p0
                              )),
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
                    Padding(
                        padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                        child: OverflowBar(
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
                                          fontSize: 14.sp,
                                          color: ThemaMain.white)),
                                  child: IconButton.filled(
                                      onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const DialogCamara()),
                                      icon: Icon(Icons.add_photo_alternate,
                                          size: 22.sp, color: Colors.white))),
                              SizedBox(
                                  width: 45.w,
                                  child: TextfieldMoney(
                                      text: montoController,
                                      field: (p0) {
                                        final tempModel = widget
                                            .provider.gastoActual
                                            .copyWith(monto: p0);
                                        widget.provider.gastoActual = tempModel;
                                      }))
                            ])),
                    TextButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) => DialogMetodoPago(
                                tipo: true,
                                metodoSelect: widget.provider.metodoSelect,
                                fun: (p0) {
                                  widget.provider.metodoSelect = p0;
                                })),
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
