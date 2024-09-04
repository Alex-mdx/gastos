import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:timelines_plus/timelines_plus.dart';

class HistorialSemanalWidget extends StatefulWidget {
  final GastoProvider provider;
  const HistorialSemanalWidget({super.key, required this.provider});

  @override
  State<HistorialSemanalWidget> createState() => _HistorialSemanalWidget();
}

class _HistorialSemanalWidget extends State<HistorialSemanalWidget> {
  List<String> dias = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.provider.obtenerDato();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
          width: 100.w,
          height: 15.h,
          child: Timeline.tileBuilder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              builder: TimelineTileBuilder.fromStyle(
                  connectorStyle: ConnectorStyle.dashedLine,
                  contentsAlign: ContentsAlign.reverse,
                  indicatorStyle: IndicatorStyle.outlined,
                  contentsBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: Text(dias[index],
                          style: TextStyle(
                              fontSize: dias[index].toLowerCase().contains(DateFormat('EEEE', 'es').format(now))
                                  ? (4).w
                                  : 3.w,
                              fontWeight: dias[index].toLowerCase().contains(DateFormat('EEEE', 'es').format(now))
                                  ? FontWeight.bold
                                  : FontWeight.normal))),
                  oppositeContentsBuilder: (context, index) => Card(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedFlipCounter(
<<<<<<< HEAD
                              value:widget.provider.contarDiaSemana(fechas: widget.provider.listaGastos.map((e) => e.fecha!).toList(), intDia: index) == 0? 0: widget.provider.generarPago(montos: widget.provider.listaGastos.where((element) => DateTime.tryParse(element.fecha!)?.weekday == index + 1).map((e) => e.monto!).toList())/widget.provider.contarDiaSemana(fechas: widget.provider.listaGastos.map((e) => e.fecha!).toList(), intDia: index),
                              duration: Durations.long3,fractionDigits: 2,
=======
                              value:  (widget.provider.contarSemana(fechas: widget.provider.listaGastos.map((e) => DateTime.parse(e.fecha!)).toList(), dia: index + 1)) == 0? 0 :  (widget.provider.generarPago(montos: widget.provider.listaGastos.where((element) => DateTime.tryParse(element.fecha!)?.weekday == index + 1).map((e) => e.monto!).toList())) / (widget.provider.contarSemana(fechas: widget.provider.listaGastos.map((e) => DateTime.parse(e.fecha!)).toList(), dia: index + 1)),
                              duration: Durations.long3,
                              fractionDigits: 2,
>>>>>>> 7c1d419dc829f80dfbe5a22b8f49ae734793f978
                              prefix: "\$",
                              textStyle: TextStyle(fontSize: 3.w, fontWeight: FontWeight.bold)))),
                  itemCount: dias.length))),
      Text('Gasto Estimado Semanal',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: (1.5).h, fontWeight: FontWeight.bold)),
      AnimatedFlipCounter(
          value: widget.provider.promedioTotalSemana(),
          duration: Durations.long3,
          fractionDigits: 2,
          prefix: "\$",
          textStyle: TextStyle(fontSize: (2).h, fontWeight: FontWeight.bold))
    ]);
  }
}
