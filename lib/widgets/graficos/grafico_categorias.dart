import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/models/categoria_model.dart';
import 'package:gastos/models/gasto_model.dart';
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
  DateTime ahora = DateTime.now();
  /* List<Map<String, dynamic>> datos = [
    {
      "fecha": "2024-05-01 11:00:55",
      "categoria_id": 1,
      "nombre": "ropa",
      "monto": 20
    },
    {
      "fecha": "2024-09-01 21:00:55",
      "categoria_id": 1,
      "nombre": "ropa",
      "monto": 209
    },
    {
      "fecha": "2023-01-09 11:00:40",
      "categoria_id": 2,
      "nombre": "bebidas",
      "monto": 20
    },
    {
      "fecha": "2024-02-01 14:20:25",
      "categoria_id": 3,
      "nombre": "lavanderia",
      "monto": 89
    },
    {
      "fecha": "2024-02-02 19:00:05",
      "categoria_id": 3,
      "nombre": "lavanderia",
      "monto": 71
    },
    {
      "fecha": "2023-09-01 10:00:05",
      "categoria_id": 2,
      "nombre": "bebidas",
      "monto": 34
    },
    {
      "fecha": "2024-06-20 20:00:55",
      "categoria_id": 4,
      "nombre": "despensa",
      "monto": 220
    },
    {
      "fecha": "2024-06-21 21:00:00",
      "categoria_id": 4,
      "nombre": "despensa",
      "monto": 130
    }
  ]; */

  late ZoomPanBehavior _zoomPanBehavior;
  late DateTimeAxis _primaryXAxis;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(animationDuration: 350, enable: true);

    _primaryXAxis =
        DateTimeAxis(intervalType: DateTimeIntervalType.months, interval: 1);
    _zoomPanBehavior = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enablePanning: true,
        zoomMode: ZoomMode.x);
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
          xValueMapper: (DatosGrafico dato, _) => dato.fecha,
          yValueMapper: (DatosGrafico dato, _) => dato.monto));
    });

    return series;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _crearSeries(ahora.subtract(Duration(days: 30 * 2)), ahora),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
                height: 60.h,
                child: Expanded(
                    child: SfCartesianChart(
                        backgroundColor: ThemaMain.dialogbackground,
                        primaryXAxis: _primaryXAxis,
                        primaryYAxis: NumericAxis(
                            majorGridLines: MajorGridLines(width: 1)),
                        title: ChartTitle(
                            text: 'Rendimiento de gasto por categoria y mes',
                            textStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: ThemaMain.darkBlue)),
                        legend: Legend(isVisible: true),
                        selectionGesture: ActivationMode.singleTap,
                        tooltipBehavior: _tooltipBehavior,
                        zoomPanBehavior: _zoomPanBehavior,
                        series: snapshot.data!)));
          } else if (snapshot.hasError) {
            return Text("Se encontro un error\n${snapshot.error}",
                style: TextStyle(fontSize: 14.sp));
          } else {
            return Column(children: [
              Text("Cargando datos", style: TextStyle(fontSize: 14.sp)),
              CircularProgressIndicator()
            ]);
          }
        });
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
