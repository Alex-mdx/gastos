import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:gastos/dialog/dialog_week_picker.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
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

  List<String> dias = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
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
                        contentsBuilder: (context, index) {
                          bool isNow = dias[index].toLowerCase().contains(
                              DateFormat('EEEE', 'es')
                                  .format(provider.todayNow));
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: .2.w),
                              child: Text(dias[index],
                                  style: TextStyle(
                                      fontSize: isNow ? 15.sp : 13.sp,
                                      fontStyle: isNow
                                          ? FontStyle.normal
                                          : FontStyle.italic,
                                      fontWeight: isNow
                                          ? FontWeight.bold
                                          : FontWeight.normal)));
                        },
                        oppositeContentsBuilder: (context, index) => SizedBox(
                            width: 14.w,
                            height: 7.h,
                            child: dias[index].toLowerCase().contains(
                                    DateFormat('EEEE', 'es').format(
                                        provider.selectFecha ?? DateTime.now()))
                                ? animation(index, provider.todayNow,
                                    fonsize: 14.sp)
                                : tarjeta(index, false, provider.todayNow)),
                        itemCount: dias.length)))),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(LineIcons.arrowCircleLeft, size: 18.sp),
                  onPressed: () => provider.todayNow =
                      provider.todayNow.subtract(Duration(days: 7))),
              TextButton(
                  child: Text(
                      "Semana ${Textos.getNumeroSemana(provider.todayNow)}",
                      style: TextStyle(fontSize: 16.sp)),
                  onPressed: () async => showDialog(
                      context: context,
                      builder: (context) => DialogWeekPicker(
                          initialDate: provider.todayNow,
                          onChanged: (fecha) => provider.todayNow = fecha))),
              IconButton(
                  icon: Icon(LineIcons.arrowCircleRight, size: 18.sp),
                  onPressed: () {
                    if (provider.todayNow.day < DateTime.now().day) {
                      provider.todayNow =
                          provider.todayNow.add(Duration(days: 7));
                    } else {
                      showToast(
                          "No se puede adelantar mas la semana a la fecha actual");
                    }
                  })
            ])
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
                value: widget.provider.promedioTotalSemana(provider.todayNow),
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
                    percent: ((widget.provider
                                    .promedioTotalSemana(provider.todayNow)) /
                                widget.provider.presupuesto!.presupuesto!) >
                            1
                        ? 1
                        : (widget.provider
                                .promedioTotalSemana(provider.todayNow)) /
                            widget.provider.presupuesto!.presupuesto!,
                    progressColor: widget.provider.porcentualColor((100 *
                            widget.provider
                                .promedioTotalSemana(provider.todayNow)) /
                        widget.provider.presupuesto!.presupuesto!)),
                AnimatedDefaultTextStyle(
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        color: widget.provider.porcentualColor((100 *
                                widget.provider
                                    .promedioTotalSemana(provider.todayNow)) /
                            widget.provider.presupuesto!.presupuesto!)),
                    duration: Durations.medium1,
                    child: AnimatedFlipCounter(
                        value: change
                            ? (widget.provider.presupuesto!.presupuesto! -
                                    widget.provider
                                        .promedioTotalSemana(provider.todayNow))
                                .abs()
                            : (100 *
                                    widget.provider.promedioTotalSemana(
                                        provider.todayNow)) /
                                widget.provider.presupuesto!.presupuesto!,
                        duration: Durations.long3,
                        fractionDigits: change ? 2 : 1,
                        prefix: change ? "\$" : null,
                        suffix: change ? null : "%"))
              ]))
      ])
    ]);
  }

  Widget animation(int index, DateTime ahora, {double? fonsize}) {
    return ZoCollectionDestination(
        key: widget.gastoKey,
        child: tarjeta(index, true, ahora, fonsize: fonsize));
  }

  Widget tarjeta(int index, bool hoy, DateTime ahora, {double? fonsize}) {
    return Card(
        shadowColor: ThemaMain.darkGrey,
        elevation: hoy ? 3 : 0,
        color: hoy ? ThemaMain.dialogbackground : null,
        child: Padding(
            padding: EdgeInsets.all(hoy ? 2.sp : 1.sp),
            child: AnimatedDefaultTextStyle(
                maxLines: 1,
                style: TextStyle(
                    fontSize: fonsize ?? 13.sp,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: hoy ? FontWeight.bold : FontWeight.normal,
                    color: widget.provider.presupuesto?.activo == 1
                        ? widget.provider.porcentualColor(widget.provider
                            .obtenerPorcentajeDia(
                                index,
                                widget.provider
                                    .promediarDiaSemana(index, ahora)))
                        : ThemaMain.primary),
                duration: Duration(seconds: 2),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AnimatedFlipCounter(
                        value: widget.provider.promediarDiaSemana(index, ahora),
                        duration: Durations.long1,
                        fractionDigits: 1,
                        prefix: "\$")))));
  }
}
