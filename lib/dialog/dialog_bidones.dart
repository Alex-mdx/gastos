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
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'dialog_historial_bidon.dart';

class DialogBidones extends StatefulWidget {
  final BidonesModel? bidon;
  const DialogBidones({super.key, this.bidon});

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
  void initState() {
    super.initState();
    if (widget.bidon != null) {
      nombre.text = widget.bidon?.nombre ?? "";
      monto.text = (widget.bidon?.montoInicial ?? "").toString();
      fechas = widget.bidon?.diasEfecto ?? [];
      categoriaId = widget.bidon?.categoria ?? [];
      metodoId = widget.bidon?.metodoPago ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      OverflowBar(children: [
        SizedBox(
            width: 48.w,
            child: Text("Bidones de Presupuesto",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)))
      ]),
      if (widget.bidon != null)
        OverflowBar(spacing: .5.w, children: [
          IconButton(
              iconSize: 20.sp,
              onPressed: () => Dialogs.showMorph(
                  title: "Aperturar bidon",
                  description:
                      "Se cerrara el bidon actual y se aperturará uno nuevo con sus mismos parametros",
                  loadingTitle: "Cerrando - Aperturando",
                  onAcceptPressed: (context) async {
                    final now = DateTime.now();
                    final cerrar =
                        widget.bidon!.copyWith(cerrado: 1, fechaFinal: now);
                    await BidonesController.update(cerrar);

                    final newBidon = widget.bidon!.copyWith(
                        gastos: [],
                        fechaInicio: now,
                        fechaFinal: now,
                        montoInicial: widget.bidon!.montoInicial,
                        montoFinal: widget.bidon!.montoInicial);
                    await BidonesController.insert(newBidon);
                    Navigation.pop();
                  }),
              icon: Icon(LineIcons.plusCircle, color: ThemaMain.green)),
          IconButton(
              iconSize: 20.sp,
              onPressed: () => Dialogs.showMorph(
                  title: "Restablecer gastos",
                  description:
                      "¿Restablecer este bidon a sus parametros iniciales?\nSe eliminaran los gastos del bidon",
                  loadingTitle: "restableciendo",
                  onAcceptPressed: (context) async {
                    var newBidon = widget.bidon!.copyWith(
                        montoFinal: widget.bidon!.montoInicial, gastos: []);
                    await BidonesController.update(newBidon);
                    Navigation.pop();
                  }),
              icon: Icon(LineIcons.spinner, color: ThemaMain.primary)),
          IconButton(
              iconSize: 20.sp,
              onPressed: () => Dialogs.showMorph(
                  title: widget.bidon!.inhabilitado == 0
                      ? "Inhabilitar bidon"
                      : "Habilitar bidon",
                  description: widget.bidon!.inhabilitado == 1
                      ? "Al habilitar el bidon este mismo vuelve estar listo para que sea afectado por los metodos y categorias qeu haya enlazado"
                      : "Si deshabilita este bidon, aquellos  metodos de pago y/o categorias vinculadas a sus gastos no afectaran en el vacio del bidon",
                  loadingTitle: widget.bidon!.inhabilitado == 1
                      ? "Habilitando"
                      : "Inhabilitando",
                  onAcceptPressed: (context) async {
                    final cate = widget.bidon!.copyWith(
                        inhabilitado: widget.bidon!.inhabilitado == 1 ? 0 : 1);
                    await BidonesController.update(cate);
                    setState(() {
                      Navigation.pop();
                    });
                  }),
              icon: Icon(
                  widget.bidon!.inhabilitado == 1
                      ? Icons.mobile_friendly
                      : Icons.mobile_off,
                  color: widget.bidon!.inhabilitado == 1
                      ? ThemaMain.green
                      : ThemaMain.darkGrey)),
          IconButton(
              iconSize: 20.sp,
              onPressed: () => Dialogs.showMorph(
                  title: "Cerrar bidon",
                  description:
                      "Si cierra este bidon ya no estara disponible para su uso, pero podra visualizarlo en reportes en dado caso que se haya afectado con sus gastos",
                  loadingTitle: "Inhabilitando",
                  onAcceptPressed: (context) async {
                    final cate =
                        widget.bidon!.copyWith(inhabilitado: 1, cerrado: 1);
                    await BidonesController.update(cate);
                    setState(() {
                      Navigation.pop();
                    });
                  }),
              icon: Icon(Icons.close_rounded, color: ThemaMain.red)),
          IconButton(
              iconSize: 20.sp,
              onPressed: () async {
                var bidones = await BidonesController.getItemsByPersonalizado(
                    query: "cerrado = 1 AND identificador = ?",
                    args: [widget.bidon!.identificador]);
                debugPrint("${bidones.length}");
                showDialog(
                    context: context,
                    builder: (context) =>
                        DialogHistorialBidon(bidones: bidones));
              },
              icon: Icon(LineIcons.listOl, color: ThemaMain.green)),
        ]),
      Divider(height: 1.h),
      widget.bidon?.inhabilitado == 1
          ? SizedBox(
              width: double.infinity,
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Text("Bidon Deshabilitado",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.sp)))))
          : Column(children: [
              TextField(
                  controller: nombre,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
                      fillColor: ThemaMain.background,
                      hintText: "Nombre del bidon")),
              tarjetaCateMet(provider),
              TextField(
                  controller: monto,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
                      fillColor: ThemaMain.background,
                      hintText: "Monto Inicial",
                      prefixIcon:
                          Icon(Icons.monetization_on, color: ThemaMain.green)))
            ]),
      ElevatedButton.icon(
          icon: Icon(Icons.group_work,
              size: 20.sp,
              color:
                  widget.bidon == null ? ThemaMain.primary : ThemaMain.green),
          onPressed: () async {
            if (widget.bidon?.inhabilitado == 1) {
              showToast("Bidon inhablitado");
            } else {
              int id = await BidonesController.getLastId();
              String word = Textos.randomWord(10);
              final now = DateTime.now();
              if (nombre.text != "") {
                if (metodoId.isNotEmpty || categoriaId.isNotEmpty) {
                  if (double.tryParse(monto.text) != null) {
                    Dialogs.showMorph(
                        title: widget.bidon == null
                            ? "Ingresar bidon"
                            : "Actualizar bidon",
                        description:
                            "¿Desea ${widget.bidon == null ? "ingresar" : "actualizar"} este bidon llamado ${nombre.text}?",
                        loadingTitle: "Guardando",
                        onAcceptPressed: (context) async {
                          BidonesModel bidon = BidonesModel(
                              id: widget.bidon?.id ?? id,
                              identificador:
                                  widget.bidon?.identificador ?? word,
                              nombre: nombre.text,
                              montoInicial: double.parse(monto.text),
                              montoFinal: double.parse(monto.text),
                              metodoPago: metodoId,
                              categoria: categoriaId,
                              diasEfecto: fechas,
                              fechaInicio: widget.bidon?.fechaInicio ?? now,
                              fechaFinal: widget.bidon?.fechaFinal ?? now,
                              cerrado: widget.bidon?.cerrado ?? 0,
                              inhabilitado: widget.bidon?.inhabilitado ?? 0,
                              gastos: widget.bidon?.gastos ?? []);
                          log("${bidon.toJson()}");
                          if (widget.bidon == null) {
                            await BidonesController.insert(bidon);
                          } else {
                            await BidonesController.update(bidon);
                          }
                          setState(() {});
                          Navigation.pop();
                        });
                  } else {
                    showToast("Ingrese un monto mayor a 0");
                  }
                } else {
                  showToast(
                      "Ingrese al menos un metodo de pago o una categoria");
                }
              } else {
                showToast("Ingrese nombre al bidon");
              }
            }
          },
          label: Text(
              widget.bidon?.inhabilitado == 1
                  ? "Inhabilitado"
                  : widget.bidon == null
                      ? "Crear"
                      : "Actualizar",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)))
    ]));
  }

  Widget tarjetaCateMet(GastoProvider provider) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Container(
                constraints: BoxConstraints(maxHeight: 38.h),
                child: ListView(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      Text(
                          "Dias que se rellenara de manera automatica\n(Si no se selecciona ningun dia, se rellenara de manera automatica cuando se vacie el bidon)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Wrap(
                          spacing: .5.w,
                          runSpacing: 0,
                          alignment: WrapAlignment.spaceAround,
                          runAlignment: WrapAlignment.spaceAround,
                          children: [
                            ChoiceChip.elevated(
                                labelPadding: EdgeInsets.all(4.sp),
                                onSelected: (value) {
                                  setState(() {
                                    if (fechas.any((element) => element == 0)) {
                                      fechas.remove(0);
                                    } else {
                                      fechas.add(0);
                                    }
                                  });
                                },
                                selected: fechas.any((element) => element == 0),
                                label: Text("Lunes",
                                    style: TextStyle(fontSize: 14.sp))),
                            ChoiceChip.elevated(
                                labelPadding: EdgeInsets.all(4.sp),
                                onSelected: (value) {
                                  setState(() {
                                    if (fechas.any((element) => element == 1)) {
                                      fechas.remove(1);
                                    } else {
                                      fechas.add(1);
                                    }
                                  });
                                },
                                selected: fechas.any((element) => element == 1),
                                label: Text("Martes",
                                    style: TextStyle(fontSize: 14.sp))),
                            ChoiceChip.elevated(
                                labelPadding: EdgeInsets.all(4.sp),
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
                                    style: TextStyle(fontSize: 14.sp))),
                            ChoiceChip.elevated(
                                labelPadding: EdgeInsets.all(4.sp),
                                onSelected: (value) {
                                  setState(() {
                                    if (fechas.any((element) => element == 3)) {
                                      fechas.remove(3);
                                    } else {
                                      fechas.add(3);
                                    }
                                  });
                                },
                                selected: fechas.any((element) => element == 3),
                                label: Text("Jueves",
                                    style: TextStyle(fontSize: 14.sp))),
                            ChoiceChip.elevated(
                                labelPadding: EdgeInsets.all(4.sp),
                                onSelected: (value) {
                                  setState(() {
                                    if (fechas.any((element) => element == 4)) {
                                      fechas.remove(4);
                                    } else {
                                      fechas.add(4);
                                    }
                                  });
                                },
                                selected: fechas.any((element) => element == 4),
                                label: Text("Viernes",
                                    style: TextStyle(fontSize: 14.sp))),
                            ChoiceChip.elevated(
                                labelPadding: EdgeInsets.all(4.sp),
                                onSelected: (value) {
                                  setState(() {
                                    if (fechas.any((element) => element == 5)) {
                                      fechas.remove(5);
                                    } else {
                                      fechas.add(5);
                                    }
                                  });
                                },
                                selected: fechas.any((element) => element == 5),
                                label: Text("Sabado",
                                    style: TextStyle(fontSize: 14.sp))),
                            ChoiceChip.elevated(
                                labelPadding: EdgeInsets.all(4.sp),
                                onSelected: (value) {
                                  setState(() {
                                    if (fechas.any((element) => element == 6)) {
                                      fechas.remove(6);
                                    } else {
                                      fechas.add(6);
                                    }
                                  });
                                },
                                selected: fechas.any((element) => element == 6),
                                label: Text("Domingo",
                                    style: TextStyle(fontSize: 14.sp)))
                          ]),
                      Divider(),
                      Text("Categorias que afectara este bidon de presupuesto",
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
                          closedHeaderPadding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          headerBuilder: (context, selectedItem, enabled) =>
                              Text(selectedItem.nombre,
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold)),
                          listItemBuilder:
                              (context, item, isSelected, onItemSelect) => ListTile(
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
                              if (!categoriaId.contains(categoria.value!.id!)) {
                                setState(() {
                                  categoriaId.add(categoria.value!.id!);
                                });
                              } else {
                                showToast("Ya ha ingresado este elemento");
                              }
                              categoria.clear();
                            }
                          }),
                      Wrap(
                          runSpacing: 0,
                          spacing: 1.w,
                          children: categoriaId
                              .map((e) => Chip(
                                  labelPadding: EdgeInsets.all(4.sp),
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
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold));
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error}",
                                              style:
                                                  TextStyle(fontSize: 12.sp));
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
                          closedHeaderPadding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
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
                              metodo.clear();
                            }
                          }),
                      Wrap(
                          spacing: 1.w,
                          children: metodoId
                              .map((e) => Chip(
                                  labelPadding: EdgeInsets.all(4.sp),
                                  onDeleted: () => setState(() {
                                        metodoId.remove(e);
                                      }),
                                  label: FutureBuilder(
                                      future:
                                          MetodoGastoController.getItem(id: e),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(snapshot.data!.nombre,
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold));
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error}",
                                              style:
                                                  TextStyle(fontSize: 12.sp));
                                        } else {
                                          return SizedBox(
                                              height: 4.w,
                                              width: 4.w,
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      })))
                              .toList())
                    ]))));
  }
}
