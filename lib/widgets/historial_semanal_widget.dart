import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HistorialSemanalWidget extends StatefulWidget {
  final GastoProvider provider;
  const HistorialSemanalWidget({super.key, required this.provider});

  @override
  State<HistorialSemanalWidget> createState() => _HistorialSemanalWidget();
}

class _HistorialSemanalWidget extends State<HistorialSemanalWidget> {
  bool change = false;
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
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          alignment: Alignment.topCenter,
          width: 100.w,
          height: 16.h,
          child: Timeline.tileBuilder(
              padding: EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              builder: TimelineTileBuilder.fromStyle(
                  connectorStyle: ConnectorStyle.dashedLine,
                  contentsAlign: ContentsAlign.reverse,
                  indicatorStyle: IndicatorStyle.outlined,
                  contentsBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: .5.w),
                      child: Text(dias[index],
                          style: TextStyle(
                              fontSize: dias[index].toLowerCase().contains(
                                      DateFormat('EEEE', 'es').format(now))
                                  ? 15.sp
                                  : 13.sp,
                              fontWeight: dias[index].toLowerCase().contains(
                                      DateFormat('EEEE', 'es').format(now))
                                  ? FontWeight.bold
                                  : FontWeight.normal))),
                  oppositeContentsBuilder: (context, index) => SizedBox(
                        width: 14.5.w,
                        height: 6.h,
                        child: Card(
                            child: Padding(
                                padding: EdgeInsets.all(4.sp),
                                child: AnimatedDefaultTextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: widget.provider.presupuesto?.activo == 1
                                            ? widget.provider.porcentualColor(
                                                widget.provider.obtenerPorcentajeDia(
                                                    index,
                                                    widget.provider
                                                        .promediarDiaSemana(
                                                            index)))
                                            : ThemaMain.primary),
                                    duration: Duration(seconds: 1),
                                    child: AnimatedFlipCounter(
                                        value: widget.provider
                                            .promediarDiaSemana(index),
                                        duration: Durations.long1,
                                        fractionDigits: 1,
                                        prefix: "\$")))),
                      ),
                  itemCount: dias.length))),
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
                  fractionDigits: 2,
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
                        fractionDigits: change ? 2 : 0,
                        prefix: change ? "\$" : null,
                        suffix: change ? null : "%"))
              ]))
      ])
    ]);
  }
}
