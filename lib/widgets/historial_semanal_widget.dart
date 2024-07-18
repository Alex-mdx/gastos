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
    "Sabado",
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
                              value: 100,
                              duration: Durations.long3,
                              prefix: "\$",
                              textStyle: TextStyle(fontSize: 3.w, fontWeight: FontWeight.bold)))),
                  itemCount: dias.length))),
      Text('Gasto Estimado Semanal',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: (1.5).h, fontWeight: FontWeight.bold)),
      AnimatedFlipCounter(
          value: 1,
          duration: Durations.long3,
          prefix: "\$",
          textStyle: TextStyle(fontSize: (2).h, fontWeight: FontWeight.bold))
    ]);
  }
}
