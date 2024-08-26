import 'dart:developer';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/dialog/s_dialog_foto_gasto.dart';
import 'package:gastos/dialog/s_dialog_periodo_gasto.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../dialog/s_dialog_camara.dart';
import '../dialog/s_dialog_categorias.dart';
import 'package:badges/badges.dart' as badges;

class CardGastoWidget extends StatefulWidget {
  const CardGastoWidget({super.key});

  @override
  State<CardGastoWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CardGastoWidget> {
  DateTime now = DateTime.now();
  TextEditingController nota = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Card(
        elevation: 2,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Center(
                  child: Text(
                      provider.convertirFecha(
                          fecha: provider.selectFecha ?? now),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.sp))),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                    width: 70.w,
                    child: CustomDropdown(
                        headerBuilder: (context, selectedItem, enabled) => Text(
                            selectedItem.nombre,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        hintText: 'Tipo de Gasto',
                        items: provider.listaCategoria,
                        listItemPadding: const EdgeInsets.only(bottom: 1),
                        listItemBuilder:
                            (context, item, isSelected, onItemSelect) =>
                                ListTile(
                                    dense: true,
                                    title: Text(item.nombre),
                                    subtitle: Text(item.descripcion)),
                        overlayHeight: 5,
                        onChanged: (value) {
                          if (value != null) {
                            final modelTemp = provider.gastoActual
                                .copyWith(categoriaId: value.id);
                            provider.gastoActual = modelTemp;
                            log("${provider.gastoActual.toJson()}");
                          }

                          log('changing value to: $value');
                        })),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              const Dialog(child: DialogCategorias()));
                    },
                    icon: const Icon(Icons.add))
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    onPressed: () async {
                      provider.selectFecha = (await showDatePicker(
                              context: context,
                              initialDatePickerMode: DatePickerMode.day,
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              initialDate: now,
                              firstDate:
                                  now.subtract(const Duration(days: 365 * 15)),
                              lastDate: now)) ??
                          now;
                      final modelTemp = provider.gastoActual.copyWith(
                          fecha: provider.convertirFechaHora(
                              fecha: provider.selectFecha ?? now),
                          dia:
                              (provider.selectFecha?.day ?? now.day).toString(),
                          mes: (provider.selectFecha?.month ?? now.month)
                              .toString());
                      provider.gastoActual = modelTemp;
                      log("${provider.gastoActual.toJson()}");
                    },
                    icon: const Icon(Icons.edit_calendar)),
                SizedBox(
                    width: 30.w,
                    child: SpinBox(
                        min: .5,
                        max: 10000,
                        value: provider.gastoActual.monto ?? 0,
                        decimals: 2,
                        acceleration: .5,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.attach_money)),
                        direction: Axis.vertical,
                        onSubmitted: (p0) {
                          final tempModel =
                              provider.gastoActual.copyWith(monto: p0);
                          provider.gastoActual = tempModel;
                        },
                        onChanged: (value) {
                          final tempModel =
                              provider.gastoActual.copyWith(monto: value);
                          provider.gastoActual = tempModel;
                        })),
                ButtonBar(children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const DialogCamara());
                      },
                      icon: const Icon(Icons.add_photo_alternate)),
                  badges.Badge(
                      showBadge: provider.imagenesActual.isNotEmpty,
                      badgeContent: Text("${provider.imagenesActual.length}"),
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => const DialogFotoGasto());
                          },
                          icon: const Icon(Icons.photo_library)))
                ])
              ]),
              Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                DialogPeriodoGasto(provider: provider));
                      },
                      label: const Text('Gasto Cronologico'),
                      icon: const Icon(Icons.calendar_month))),
              const Divider(),
              TextField(
                  controller: nota,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    final tempModel =
                        provider.gastoActual.copyWith(nota: nota.text);
                    provider.gastoActual = tempModel;
                  },
                  onSubmitted: (value) {
                    log("${provider.gastoActual.toJson()}");
                  },
                  decoration: const InputDecoration(hintText: "Notas de gasto"))
            ])));
  }
}
