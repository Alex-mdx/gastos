import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/models/categoria_model.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficoCategorias extends StatefulWidget {
  const GraficoCategorias({super.key});

  @override
  State<GraficoCategorias> createState() => _GraficoCategoriasState();
}

class _GraficoCategoriasState extends State<GraficoCategorias> {
  late TooltipBehavior _tooltipBehavior;
  DateTime ahora = DateTime.now();
  late DateTimeAxis _primaryXAxis;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(animationDuration: 350, enable: true);

    _primaryXAxis = DateTimeAxis(
        labelStyle: TextStyle(color: ThemaMain.darkGrey),
        intervalType: DateTimeIntervalType.days,
        interval: 1);
  }

  Future<List<LineSeries<DatosGrafico, DateTime>>> _crearSeries(
      DateTime fechaI, DateTime fechaF) async {
    Map<int, List<GastoModelo>> datosPorCategoria = {};

    List<LineSeries<DatosGrafico, DateTime>> series = [];
    var datos =
        await GastosController.obtenerFechasEnRangoOnlyMF(fechaI, fechaF);

    for (var dato in datos) {
      int categoriaId = dato.categoriaId!;
      if (!datosPorCategoria.containsKey(categoriaId)) {
        datosPorCategoria[categoriaId] = [];
      }
      datosPorCategoria[categoriaId]!.add(dato);
    }
    List<CategoriaModel> cates = await CategoriaController.getItems();

    datosPorCategoria.forEach((categoriaId, datosCategoria) {
      String nombreCategoria = cates
              .firstWhereOrNull((element) => element.id == categoriaId)
              ?.nombre ??
          "Sin nombre";
      // Convertir los datos en una lista de DatosGrafico
      List<DatosGrafico> puntos = datosCategoria
          .map((dato) => DatosGrafico(
              fecha: DateTime.parse(dato.fecha!),
              monto: dato.monto ?? 0,
              nombreCategoria: nombreCategoria))
          .toList();

      // Ordenar por fecha
      puntos.sort((a, b) => a.fecha.compareTo(b.fecha));

      // Crear la serie para esta categoría
      series.add(LineSeries<DatosGrafico, DateTime>(
          name: nombreCategoria,
          dataSource: puntos,
          enableTrackball: true,
          enableTooltip: true,
          dataLabelSettings:
              DataLabelSettings(textStyle: TextStyle(color: ThemaMain.second)),
          onPointLongPress: (pointInteractionDetails) {
            if (kDebugMode) {
              showToast("Test");
            }
          },
          onPointDoubleTap: (pointInteractionDetails) => kDebugMode
              ? showToast("Mantenga presionado para ver detalles")
              : null,
          xValueMapper: (DatosGrafico dato, _) => dato.fecha,
          yValueMapper: (DatosGrafico dato, _) => dato.monto,
          markerSettings: MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              borderColor: ThemaMain.second)));
    });

    return series;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 65.h,
        child: FutureBuilder(
            future: _crearSeries(ahora.subtract(Duration(days: 30 * 1)), ahora),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return SfCartesianChart(
                    margin: EdgeInsets.all(10.sp),
                    backgroundColor: ThemaMain.dialogbackground,
                    primaryXAxis: _primaryXAxis,
                    primaryYAxis: NumericAxis(
                        numberFormat: NumberFormat.compactCurrency(
                            symbol: "\$", decimalDigits: 1),
                        labelStyle: TextStyle(
                            color: ThemaMain.darkGrey,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold),
                        majorGridLines: MajorGridLines(
                            width: 1,
                            color: Colors.grey.withAlpha(170),
                            dashArray: <double>[5, 5])),
                    title: ChartTitle(
                        text: 'Rendimiento de gasto por categoria',
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: ThemaMain.darkBlue)),
                    legend: Legend(
                        textStyle: TextStyle(color: ThemaMain.darkBlue),
                        isVisible: true,
                        itemPadding: 8,
                        isResponsive: true,
                        padding: 6,
                        position: LegendPosition.top,
                        overflowMode: LegendItemOverflowMode.wrap,
                        shouldAlwaysShowScrollbar: true),
                    selectionGesture: ActivationMode.singleTap,
                    tooltipBehavior: _tooltipBehavior,
                    series: snapshot.data!);
              } else if (snapshot.hasError) {
                return Text("Se encontro un error\n${snapshot.error}",
                    style: TextStyle(fontSize: 14.sp));
              } else {
                return Column(children: [
                  Text("Cargando datos", style: TextStyle(fontSize: 14.sp)),
                  CircularProgressIndicator()
                ]);
              }
            }));
  }
}

class DatosGrafico {
  final DateTime fecha;
  final double monto;
  final String nombreCategoria;

  DatosGrafico(
      {required this.fecha,
      required this.monto,
      required this.nombreCategoria});
}
