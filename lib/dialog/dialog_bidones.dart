import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/bidones_controller.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/models/bidones_model.dart';
import 'package:gastos/models/categoria_model.dart';
import 'package:gastos/models/metodo_pago_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DialogBidones extends StatefulWidget {
  const DialogBidones({super.key});

  @override
  State<DialogBidones> createState() => _DialogBidonesState();
}

class _DialogBidonesState extends State<DialogBidones> {
  List<int> fechas = [];
  SingleSelectController<CategoriaModel> categoria =
      SingleSelectController(null);
  SingleSelectController<MetodoPagoModel> metodo = SingleSelectController(null);
  TextEditingController nombre = TextEditingController();
  TextEditingController monto = TextEditingController();
  List<int> categoriaId = [];
  List<int> metodoId = [];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("Bidones de Presupuesto",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
      Divider(height: 1.h),
      Container(
          constraints: BoxConstraints(maxHeight: 80.h),
          child: Scrollbar(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Card(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                        TextField(
                            keyboardType: TextInputType.text,
                            decoration:
                                InputDecoration(hintText: "Nombre del bidon")),
                        Text(
                            "Dias que se rellenara de manera automatica\n(Si no se selecciona ninguna, se rellenara de manera automatica hasta el que bidon este vacio)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        Wrap(
                            spacing: .5.w,
                            alignment: WrapAlignment.spaceAround,
                            runAlignment: WrapAlignment.spaceAround,
                            children: [
                              ChoiceChip.elevated(
                                  onSelected: (value) {
                                    setState(() {
                                      if (fechas
                                          .any((element) => element == 0)) {
                                        fechas.remove(0);
                                      } else {
                                        fechas.add(0);
                                      }
                                    });
                                  },
                                  selected:
                                      fechas.any((element) => element == 0),
                                  label: Text("Lunes",
                                      style: TextStyle(fontSize: 14.sp))),
                              ChoiceChip.elevated(
                                  onSelected: (value) {
                                    setState(() {
                                      if (fechas
                                          .any((element) => element == 1)) {
                                        fechas.remove(1);
                                      } else {
                                        fechas.add(1);
                                      }
                                    });
                                  },
                                  selected:
                                      fechas.any((element) => element == 1),
                                  label: Text("Martes",
                                      style: TextStyle(fontSize: 14.sp))),
                              ChoiceChip.elevated(
                                onSelected: (value) {
                                  setState(() {
                                    if (fechas.any((element) => element == 2)) {
                                      fechas.remove(2);
                                    } else {
                                      fechas.add(2);
                                    }
                                  });
                                },
                                selected: fechas.any((element) => element == 2),
                                label: Text("Miercoles",
                                    style: TextStyle(fontSize: 14.sp)),
                              ),
                              ChoiceChip.elevated(
                                  onSelected: (value) {
                                    setState(() {
                                      if (fechas
                                          .any((element) => element == 3)) {
                                        fechas.remove(3);
                                      } else {
                                        fechas.add(3);
                                      }
                                    });
                                  },
                                  selected:
                                      fechas.any((element) => element == 3),
                                  label: Text("Jueves",
                                      style: TextStyle(fontSize: 14.sp))),
                              ChoiceChip.elevated(
                                  onSelected: (value) {
                                    setState(() {
                                      if (fechas
                                          .any((element) => element == 4)) {
                                        fechas.remove(4);
                                      } else {
                                        fechas.add(4);
                                      }
                                    });
                                  },
                                  selected:
                                      fechas.any((element) => element == 4),
                                  label: Text("Viernes",
                                      style: TextStyle(fontSize: 14.sp))),
                              ChoiceChip.elevated(
                                  onSelected: (value) {
                                    setState(() {
                                      if (fechas
                                          .any((element) => element == 5)) {
                                        fechas.remove(5);
                                      } else {
                                        fechas.add(5);
                                      }
                                    });
                                  },
                                  selected:
                                      fechas.any((element) => element == 5),
                                  label: Text("Sabado",
                                      style: TextStyle(fontSize: 14.sp))),
                              ChoiceChip.elevated(
                                  onSelected: (value) {
                                    setState(() {
                                      if (fechas
                                          .any((element) => element == 6)) {
                                        fechas.remove(6);
                                      } else {
                                        fechas.add(6);
                                      }
                                    });
                                  },
                                  selected:
                                      fechas.any((element) => element == 6),
                                  label: Text("Domingo",
                                      style: TextStyle(fontSize: 14.sp)))
                            ]),
                        Text(
                            "Categorias que afectara este bidon de presupuesto",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        CustomDropdown.searchRequest(
                            futureRequest: (p0) async =>
                                await CategoriaController.buscar(p0),
                            hintText: 'Categorias',
                            controller: categoria,
                            items: provider.listaCategoria,
                            itemsListPadding: EdgeInsets.all(0),
                            listItemPadding: EdgeInsets.all(0),
                            headerBuilder: (context, selectedItem, enabled) =>
                                Text(selectedItem.nombre,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold)),
                            listItemBuilder: (context, item, isSelected,
                                    onItemSelect) =>
                                ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 1.w),
                                    title: Text(item.nombre,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(item.descripcion,
                                        maxLines: 2,
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold))),
                            onChanged: (p0) {
                              if (p0 != null) {
                                if (!categoriaId
                                    .contains(categoria.value!.id!)) {
                                  setState(() {
                                    categoriaId.add(categoria.value!.id!);
                                  });
                                } else {
                                  showToast("Ya ha ingresado este elemento");
                                }
                              }
                            }),
                        Wrap(
                            runSpacing: 0,
                            spacing: 1.w,
                            children: categoriaId
                                .map((e) => Chip(
                                    onDeleted: () => setState(() {
                                          categoriaId.remove(e);
                                        }),
                                    label: FutureBuilder(
                                        future:
                                            CategoriaController.getItem(id: e),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(snapshot.data!.nombre,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.bold));
                                          } else if (snapshot.hasError) {
                                            return Text("${snapshot.error}",
                                                style:
                                                    TextStyle(fontSize: 14.sp));
                                          } else {
                                            return SizedBox(
                                                height: 4.w,
                                                width: 4.w,
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        })))
                                .toList()),
                        Divider(),
                        Text(
                            "Metodos de pago que afectara este bidon de presupuesto",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        CustomDropdown.searchRequest(
                            futureRequest: (p0) async =>
                                await MetodoGastoController.buscar(p0),
                            hintText: 'Metodo de pago',
                            controller: metodo,
                            itemsListPadding: EdgeInsets.all(0),
                            listItemPadding: EdgeInsets.all(0),
                            headerBuilder: (context, selectedItem, enabled) =>
                                Text(selectedItem.nombre,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold)),
                            listItemBuilder:
                                (context, item, isSelected, onItemSelect) =>
                                    ListTile(
                                        title: Text(item.nombre,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold))),
                            items: provider.metodo,
                            onChanged: (p0) {
                              if (p0 != null) {
                                if (!metodoId.contains(metodo.value!.id)) {
                                  setState(() {
                                    metodoId.add(metodo.value!.id);
                                  });
                                } else {
                                  showToast("Ya ha ingresado este elemento");
                                }
                              }
                            }),
                        Wrap(
                            spacing: 1.w,
                            children: metodoId
                                .map((e) => Chip(
                                    onDeleted: () => setState(() {
                                          metodoId.remove(e);
                                        }),
                                    label: FutureBuilder(
                                        future: MetodoGastoController.getItem(
                                            id: e),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(snapshot.data!.nombre,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.bold));
                                          } else if (snapshot.hasError) {
                                            return Text("${snapshot.error}",
                                                style:
                                                    TextStyle(fontSize: 14.sp));
                                          } else {
                                            return SizedBox(
                                                height: 4.w,
                                                width: 4.w,
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        })))
                                .toList()),
                        Divider(),
                        TextField(
                            controller: nombre,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            decoration: InputDecoration(
                                hintText: "Monto Inicial",
                                prefixIcon: Icon(Icons.monetization_on,
                                    color: LightThemeColors.green)))
                      ])))))),
      ElevatedButton.icon(
          icon: Icon(Icons.group_work, size: 20.sp),
          onPressed: () async {
            int id = await BidonesController.getLastId();
            String word = Textos.randomWord(10);
            final now = DateTime.now();
            BidonesModel bidon = BidonesModel(
                id: id,
                identificador: word,
                nombre: nombre.text,
                montoInicial: double.parse(monto.text),
                montoFinal: 0,
                metodoPago: metodoId,
                categoria: categoriaId,
                diasEfecto: fechas,
                fechaInicio: now,
                fechaFinal: now,
                cerrado: 0,
                gastos: []);
            log("${bidon.toJson()}");
          },
          label: Text("Crear",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)))
    ]));
  }
}
