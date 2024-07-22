import 'dart:developer';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/dialog/s_dialog_foto_gasto.dart';
import 'package:gastos/dialog/s_dialog_periodo_gasto.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../dialog/s_dialog_categorias.dart';
import 'package:badges/badges.dart' as badges;

class CardGastoWidget extends StatelessWidget {
  const CardGastoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final provider = Provider.of<GastoProvider>(context);
    return Card(
        elevation: 2,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              ButtonBar(children: [
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
                    onPressed: () {
                      showDatePicker(
                          context: context,
                          initialDatePickerMode: DatePickerMode.day,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          initialDate: now,
                          firstDate:
                              now.subtract(const Duration(days: 365 * 10)),
                          lastDate: now);
                    },
                    icon: const Icon(Icons.edit_calendar)),
                SizedBox(
                    width: 30.w,
                    child: SpinBox(
                        min: .5,
                        max: 10000,
                        value: 50,
                        decimals: 2,
                        acceleration: .5,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.attach_money)),
                        direction: Axis.vertical,
                        onChanged: (value) => print(value))),
                ButtonBar(children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Ingresar evidencia'),
                                          ElevatedButton.icon(
                                              onPressed: () async {
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                final XFile? photo =
                                                    await picker.pickImage(
                                                        source:
                                                            ImageSource.camera,
                                                        requestFullMetadata:
                                                            false);
                                                if (photo != null) {
                                                  final data =
                                                      await photo.readAsBytes();
                                                  provider.imagenesActual
                                                      .add(data);
                                                }
                                              },
                                              label: const Text('Camara'),
                                              icon:
                                                  const Icon(Icons.camera_alt)),
                                          ElevatedButton.icon(
                                              onPressed: () async {
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                final List<XFile> images =
                                                    await picker.pickMultiImage(
                                                        limit: 10,
                                                        requestFullMetadata:
                                                            false);
                                                if (images.isNotEmpty) {
                                                  for (var element in images) {
                                                    final data = await element
                                                        .readAsBytes();
                                                    provider.imagenesActual
                                                        .add(data);
                                                  }
                                                }
                                              },
                                              label: const Text('galleria'),
                                              icon: const Icon(
                                                  Icons.image_search))
                                        ])),
                              );
                            });
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
                            builder: (context) => const DialogPeriodoGasto());
                      },
                      label: const Text('Gasto Cronologico'),
                      icon: const Icon(Icons.calendar_month)))
            ])));
  }
}
