import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DialogBidones extends StatefulWidget {
  const DialogBidones({super.key});

  @override
  State<DialogBidones> createState() => _DialogBidonesState();
}

class _DialogBidonesState extends State<DialogBidones> {
  List<int> fechas = [];
  single
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("Bidones de Presupuesto",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
      Divider(height: 1.h),
      Padding(
          padding: EdgeInsets.all(8.sp),
          child: Card(
              child: Column(children: [
            TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "Nombre del bidon")),
            Text("Dias que se rellenara de manera automatica",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            Wrap(
                spacing: .5.w,
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.spaceAround,
                children: [
                  ChoiceChip.elevated(
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
                    label: Text("Lunes", style: TextStyle(fontSize: 14.sp)),
                  ),
                  ChoiceChip.elevated(
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
                      label: Text("Martes", style: TextStyle(fontSize: 14.sp))),
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
                    label: Text("Miercoles", style: TextStyle(fontSize: 14.sp)),
                  ),
                  ChoiceChip.elevated(
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
                      label: Text("Jueves", style: TextStyle(fontSize: 14.sp))),
                  ChoiceChip.elevated(
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
                      label:
                          Text("Viernes", style: TextStyle(fontSize: 14.sp))),
                  ChoiceChip.elevated(
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
                      label: Text("Sabado", style: TextStyle(fontSize: 14.sp))),
                  ChoiceChip.elevated(
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
                      label: Text("Domingo", style: TextStyle(fontSize: 14.sp)))
                ]),
            Text("Categorias que afectara este bidon de presupuesto",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            CustomDropdown.searchRequest(
              futureRequest: (p0) async => await CategoriaController.buscar(p0),
              hintText: 'Categorias',
              items: provider.listaCategoria,
              onChanged: (p0) {},
            ),
            Divider(),
            Text("Metodos de pago que afectara este bidon de presupuesto",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            CustomDropdown.searchRequest(
              futureRequest: (p0) async =>
                  await MetodoGastoController.buscar(p0),
              hintText: 'Metodo de pago',listItemBuilder: (context, item, isSelected, onItemSelect) => ListTile(),
              items: provider.metodo,
              onChanged: (p0) {}
            ),
            Divider(),
            TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                decoration: InputDecoration(hintText: "\$Monto Inicial")),
            ElevatedButton.icon(
                icon: Icon(Icons.group_work, size: 20.sp),
                onPressed: () {},
                label: Text("Crear",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)))
          ])))
    ]));
  }
}
