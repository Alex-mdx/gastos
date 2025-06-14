import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return FutureBuilder(
        future: CategoriaController.getItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              children: [
                Text("Cargando Categorias"),
                CircularProgressIndicator(),
              ]
            );
          }
          final categorias = snapshot.data!;
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
              annotations: [
                CartesianChartAnnotation(
                    widget: FutureBuilder(
                        future: GastosController.getCategoriaByMes(
                            categoriaId: 1, mes: 4),
                        builder: (context, snapshot) {
                          return Text("${snapshot.data ?? 1}");
                        }),
                    x: 90,
                    y: 20)
              ],
              selectionGesture: ActivationMode.singleTap,
              tooltipBehavior: _tooltipBehavior,
              series: categorias
                  .map((e) =>  LineSeries(
                      dataSource: meses
                          .map((mes) => SalesData(Textos.obtenerMes(mes), 0))
                          .toList(),
                      xValueMapper: (SalesData sales, _) => sales.year,
                      name: e.nombre,
                      yValueMapper: (SalesData sales, _) => sales.sales,
                      dataLabelSettings: DataLabelSettings(
                          textStyle: TextStyle(
                              fontSize: 13.sp, color: ThemaMain.darkGrey),
                          isVisible: true)))
                  .toList());
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
