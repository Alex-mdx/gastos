import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:zo_collection_animation/zo_collection_animation.dart';

class HistorialSemanalWidget extends StatefulWidget {
  final GastoProvider provider;
  final GlobalKey gastoKey;
  const HistorialSemanalWidget(
      {super.key, required this.provider, required this.gastoKey});

  @override
  State<HistorialSemanalWidget> createState() => _HistorialSemanalWidget();
}

class _HistorialSemanalWidget extends State<HistorialSemanalWidget> {
  bool change = false;
  Timer? verificacion;

  List<String> dias = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];
  var now = DateTime.now();

  @override
  void initState() {
    super.initState();
    time();
  }

  void time() {
    verificacion = Timer.periodic(
        Duration(minutes: 1),
        (timer) => setState(() {
              now = DateTime.now();
            }));
  }

  @override
  void dispose() {
    verificacion?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Stack(alignment: Alignment.topCenter, children: [
        SizedBox(
            width: 100.w,
            height: 13.h,
            child: Align(
                alignment: Alignment.topCenter,
                child: Timeline.tileBuilder(
                    padding: EdgeInsets.all(0),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    builder: TimelineTileBuilder.fromStyle(
                        connectorStyle: ConnectorStyle.dashedLine,
                        contentsAlign: ContentsAlign.reverse,
                        indicatorStyle: IndicatorStyle.outlined,
                        contentsBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: .2.w),
                            child: Text(dias[index],
                                style: TextStyle(
                                    fontSize: dias[index].toLowerCase().contains(DateFormat('EEEE', 'es').format(now))
                                        ? 15.sp
                                        : 13.sp,
                                    fontStyle: dias[index].toLowerCase().contains(DateFormat('EEEE', 'es').format(now))
                                        ? FontStyle.normal
                                        : FontStyle.italic,
                                    fontWeight: FontWeight.bold))),
                        oppositeContentsBuilder: (context, index) => SizedBox(
                            width: 14.5.w,
                            height: 7.h,
                            child: dias[index].toLowerCase().contains(DateFormat('EEEE', 'es').format(now))
                                ? ShakeWidget(
                                    duration: Duration(seconds: 1),
                                    shakeConstant: ShakeHorizontalConstant2(),
                                    autoPlay: widget.provider.vibrarDia,
                                    child: animation(index))
                                : tarjeta(index, false)),
                        itemCount: dias.length)))),
        TextButton(
            child: Text("Semana ${Textos.getNumeroSemana(now)}",
                style: TextStyle(fontSize: 16.sp)),
            onPressed: () {})
      ]),
      Row(children: [
        Expanded(
            flex: 5,
            child: Text('Gasto Actual',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold))),
        if (widget.provider.presupuesto?.presupuesto != null &&
            widget.provider.presupuesto?.activo == 1)
          Expanded(
              flex: 5,
              child: Text('Presupuesto Limite',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold))),
        if (widget.provider.presupuesto?.presupuesto != null &&
            widget.provider.presupuesto?.activo == 1)
          Expanded(
              flex: 6,
              child: TextButton.icon(
                  onPressed: () => setState(() {
                        change = !change;
                      }),
                  icon: Icon(LineIcons.alternateExchange, size: 16.sp),
                  label: Text(change ? "Cambio \$" : "Limite %",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold))))
      ]),
      Row(children: [
        Expanded(
            flex: 5,
            child: AnimatedFlipCounter(
                value: widget.provider.promedioTotalSemana(),
                duration: Durations.long3,
                fractionDigits: 2,
                prefix: "\$",
                textStyle:
                    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold))),
        if (widget.provider.presupuesto?.presupuesto != null &&
            widget.provider.presupuesto?.activo == 1)
          Expanded(
              flex: 5,
              child: AnimatedFlipCounter(
                  value: widget.provider.presupuesto!.presupuesto!,
                  duration: Durations.long3,
                  fractionDigits: 1,
                  prefix: "\$",
                  textStyle:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold))),
        if (widget.provider.presupuesto?.presupuesto != null &&
            widget.provider.presupuesto?.activo == 1)
          Expanded(
              flex: 6,
              child: Column(children: [
                LinearPercentIndicator(
                    width: 37.w,
                    animation: true,
                    addAutomaticKeepAlive: false,
                    animateFromLastPercent: true,
                    backgroundColor: ThemaMain.dialogbackground,
                    barRadius: Radius.circular(borderRadius),
                    lineHeight: 1.2.h,
                    percent: ((widget.provider.promedioTotalSemana()) /
                                widget.provider.presupuesto!.presupuesto!) >
                            1
                        ? 1
                        : (widget.provider.promedioTotalSemana()) /
                            widget.provider.presupuesto!.presupuesto!,
                    progressColor: widget.provider.porcentualColor(
                        (100 * widget.provider.promedioTotalSemana()) /
                            widget.provider.presupuesto!.presupuesto!)),
                AnimatedDefaultTextStyle(
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: widget.provider.porcentualColor(
                            (100 * widget.provider.promedioTotalSemana()) /
                                widget.provider.presupuesto!.presupuesto!)),
                    duration: Durations.medium1,
                    child: AnimatedFlipCounter(
                        value: change
                            ? (widget.provider.presupuesto!.presupuesto! -
                                    widget.provider.promedioTotalSemana())
                                .abs()
                            : (100 * widget.provider.promedioTotalSemana()) /
                                widget.provider.presupuesto!.presupuesto!,
                        duration: Durations.long3,
                        fractionDigits: change ? 2 : 1,
                        prefix: change ? "\$" : null,
                        suffix: change ? null : "%"))
              ]))
      ])
    ]);
  }

  Widget animation(int index) {
    return ZoCollectionDestination(
        key: widget.gastoKey, child: tarjeta(index, true));
  }

  Widget tarjeta(int index, bool hoy) {
    return Card(
        shadowColor: ThemaMain.darkGrey,
        elevation: hoy ? 3 : 0,
        color: hoy ? ThemaMain.dialogbackground : null,
        child: Padding(
            padding: EdgeInsets.all(2.sp),
            child: AnimatedDefaultTextStyle(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: hoy ? FontWeight.bold : FontWeight.normal,
                    color: widget.provider.presupuesto?.activo == 1
                        ? widget.provider.porcentualColor(widget.provider
                            .obtenerPorcentajeDia(index,
                                widget.provider.promediarDiaSemana(index)))
                        : ThemaMain.primary),
                duration: Duration(seconds: 2),
                child: AnimatedFlipCounter(
                    value: widget.provider.promediarDiaSemana(index),
                    duration: Durations.long1,
                    fractionDigits: 1,
                    prefix: "\$"))));
  }
}
