import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficoCategorias extends StatefulWidget {
  const GraficoCategorias({super.key});

  @override
  State<GraficoCategorias> createState() => _GraficoCategoriasState();
}

class _GraficoCategoriasState extends State<GraficoCategorias> {
  late TooltipBehavior _tooltipBehavior;
  List<int> meses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  Future<List<Map<String, dynamic>>> getData(
      {required List<int> categorias}) async {
    List<Map<String, dynamic>> datas = [];
    for (var cate in categorias) {
      var sales = meses.map((e) async {
        double monto =
            await GastosController.getCategoriaByMes(categoriaId: cate, mes: e);
        return {"year": Textos.obtenerMes(e), "sales": monto};
      }).toList();
      var newSales = await Future.wait(sales);
      datas.add({"categoria_id": cate, "sales": newSales});
    }
    return datas;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return FutureBuilder(
        future: CategoriaController.getItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(children: [
              Text("Cargando Categorias"),
              CircularProgressIndicator()
            ]);
          }
          final categorias = snapshot.data!;
          return FutureBuilder(
              future:
                  getData(categorias: categorias.map((e) => e.id!).toList()),
              builder: (context, shot) {
                if (!shot.hasData) {
                  return Column(children: [
                    Text("Cargando Gastos"),
                    CircularProgressIndicator()
                  ]);
                } else if (shot.hasError) {
                  return Text("${shot.error}");
                }
                final promedios = shot.data!;
                return SfCartesianChart(
                    backgroundColor: ThemaMain.dialogbackground,
                    primaryXAxis: CategoryAxis(),
                    // Chart title
                    title: ChartTitle(
                        text: 'Rendimiento de gasto por categoria y mes',
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: ThemaMain.darkBlue)),
                    legend: Legend(isVisible: true),
                    selectionGesture: ActivationMode.singleTap,
                    tooltipBehavior: _tooltipBehavior,
                    series: categorias.map((e) {
                      return LineSeries(
                          dataSource: promedios
                              .firstWhere((element) =>
                                  element["categoria_id"] == e.id!)["sales"]
                              .map((mes) {
                            return SalesData(mes["year"] ?? "1",
                                double.parse(mes["sales"].toString()));
                          }).toList(),
                          xValueMapper: (SalesData sales, _) => sales.year,
                          name: e.nombre,
                          yValueMapper: (SalesData sales, _) => sales.sales,
                          dataLabelSettings: DataLabelSettings(
                              textStyle: TextStyle(
                                  fontSize: 13.sp, color: ThemaMain.darkGrey),
                              isVisible: true));
                    }).toList());
              });
        });
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

/*
provider.listaCategoria
            .map((e) => LineSeries(
                dataSource: meses.map((mes) =>  SalesData(
                          Textos.obtenerMes(mes),))
                    .toList(),
                xValueMapper: (SalesData sales, _) => sales.year,
                name: e.nombre,
                yValueMapper: (SalesData sales, _) => sales.sales,
                dataLabelSettings: DataLabelSettings(
                    textStyle:
                        TextStyle(fontSize: 13.sp, color: ThemaMain.darkGrey),
                    isVisible: true)))
            .toList()
 LineSeries<SalesData, String>(
              dataSource: <SalesData>[
                SalesData('Enero', 35),
                SalesData('Febrero', 28),
                SalesData('Marzo', 34),
                SalesData('Abril', 32),
                SalesData('Mayo', 40),
                SalesData('Junio', 40),
                SalesData('Julio', 40),
                SalesData('Agosto', 40),
                SalesData('Septiebre', 40),
                SalesData('Octubre', 40),
                SalesData('Noviembre', 40),
                SalesData('Diciembre', 40)
              ],
              xValueMapper: (SalesData sales, _) => sales.year,
              name: "Gas",
              yValueMapper: (SalesData sales, _) => sales.sales,
              dataLabelSettings: DataLabelSettings(
                  textStyle:
                      TextStyle(fontSize: 13.sp, color: ThemaMain.darkGrey),
                  isVisible: true)) */
