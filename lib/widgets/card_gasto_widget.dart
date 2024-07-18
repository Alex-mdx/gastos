import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../dialog/s_dialog_categorias.dart';

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
                        showBottomSheet(
                            context: context,
                            enableDrag: true,
                            builder: (context) {
                              return Padding(
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
                                            },
                                            label: const Text('Camara'),
                                            icon: const Icon(Icons.camera_alt)),
                                        ElevatedButton.icon(
                                            onPressed: () async {
                                              final ImagePicker picker =
                                                  ImagePicker();
                                              final List<XFile> images =
                                                  await picker.pickMultiImage(
                                                      requestFullMetadata:
                                                          false);
                                            },
                                            label: const Text('galleria'),
                                            icon:
                                                const Icon(Icons.image_search))
                                      ]));
                            });
                      },
                      icon: const Icon(Icons.add_photo_alternate)),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const Dialog(
                                child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Archivo de evidencia'),
                                          Divider(),
                                          Wrap(children: [])
                                        ]))));
                      },
                      icon: const Icon(Icons.photo_library))
                ])
              ]),
              Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                      onPressed: () {},
                      label: const Text('Gasto Cronologico'),
                      icon: const Icon(Icons.calendar_month)))
            ])));
  }
}
