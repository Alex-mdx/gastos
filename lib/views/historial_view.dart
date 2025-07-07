import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:badges/badges.dart' as bd;
import '../dialog/dialog_historial_pago.dart';
import '../models/gasto_model.dart';

class HistorialView extends StatefulWidget {
  const HistorialView({super.key});

  @override
  State<HistorialView> createState() => _HistorialViewState();
}

class _HistorialViewState extends State<HistorialView> {
  DateTime first = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime last = DateTime(DateTime.now().year, DateTime.now().month, 30);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => obtenerFechas());
  }

  final now = DateTime.now();

  List<GastoModelo> lista = [];

  Future<List<GastoModelo>> obtenerFechas() async {
    var data = await GastosController.obtenerFechasEnRangoMes(first, last);
    if (mounted) {
      setState(() {
        lista = data;
      });
    } else {
      debugPrint('Widget no montado, omitiendo setState()');
    }

    return data;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 6.h,
            title: Text("Historial", style: TextStyle(fontSize: 20.sp))),
        body: SfCalendar(
            view: CalendarView.month,
            onViewChanged: (viewChangedDetails) async {
              first = viewChangedDetails.visibleDates.first;
              last = DateTime(
                  viewChangedDetails.visibleDates.last.year,
                  viewChangedDetails.visibleDates.last.month,
                  viewChangedDetails.visibleDates.last.day,
                  23,
                  59,
                  59);
              await obtenerFechas();
              log("$first - $last");
            },
            initialSelectedDate: DateTime.now(),
            initialDisplayDate:
                DateTime(DateTime.now().year, DateTime.now().month, 1),
            showDatePickerButton: true,
            allowViewNavigation: true,
            showWeekNumber: false,
            backgroundColor: ThemaMain.second,
            showNavigationArrow: true,
            showTodayButton: true,
            showCurrentTimeIndicator: true,
            allowAppointmentResize: true,
            monthCellBuilder: (context, details) {
              double montoDay = provider.sumatoriaDiaCalendario(
                  DateTime(
                      details.date.year, details.date.month, details.date.day),
                  lista);
              return Container(
                  decoration: BoxDecoration(border: Border.all(width: .1)),
                  child: Column(children: [
                    Padding(
                        padding: EdgeInsets.all(5.sp),
                        child: Container(
                            height: 6.w,
                            width: 6.w,
                            decoration: details.date.isAtSameMomentAs(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day))
                                ? BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(borderRadius),
                                    color: ThemaMain.white)
                                : null,
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(details.date.day.toString(),
                                    style: TextStyle(fontSize: 16.sp))))),
                    if (montoDay != 0)
                      Center(
                          child: Text(
                              "\$${Textos.moneda(moneda: montoDay, digito: 1)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)))
                  ]));
            },
            viewNavigationMode: ViewNavigationMode.snap,
            dataSource:
                _getCalendarDataSource(provider: provider, lista: lista),
            viewHeaderHeight: 2.h,
            firstDayOfWeek: 1,
            todayTextStyle: TextStyle(color: ThemaMain.green),
            cellBorderColor: ThemaMain.white,
            cellEndPadding: 1,
            viewHeaderStyle: ViewHeaderStyle(backgroundColor: ThemaMain.white),
            headerHeight: 4.h,
            appointmentBuilder: (context, calendarAppointmentDetails) {
              final Appointment appointment =
                  calendarAppointmentDetails.appointments.first;
              return historial(
                  provider: provider,
                  appointment: appointment,
                  calendar: calendarAppointmentDetails,
                  context: context,
                  fun: () async => await obtenerFechas());
            },
            monthViewSettings: MonthViewSettings(
                appointmentDisplayCount: 10,
                showTrailingAndLeadingDates: true,
                agendaItemHeight: 7.h,
                showAgenda: true,
                numberOfWeeksInView: 5),
            timeSlotViewSettings: const TimeSlotViewSettings(
                minimumAppointmentDuration: Duration(minutes: 60))));
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

AppointmentDataSource _getCalendarDataSource(
    {required GastoProvider provider, required List<GastoModelo> lista}) {
  List<Appointment> appointments = <Appointment>[];
  for (var i = 0; i < lista.length; i++) {
    appointments.add(Appointment(
        id: lista[i].id,
        startTime: DateTime.parse(lista[i].fecha!),
        endTime: DateTime.parse(lista[i].fecha!),
        isAllDay: false,
        location: lista[i].evidencia.length.toString(),
        notes: lista[i].metodoPagoId.toString(),
        subject:
            'Gasto: \$${lista[i].monto} - Categoria: ${provider.listaCategoria.firstWhereOrNull((element) => element.id == lista[i].categoriaId)?.nombre ?? "Sin Categoria"}',
        color: provider.presupuesto?.activo == 0 || provider.presupuesto == null
            ? ThemaMain.primary
            : provider.porcentualColor(provider.obtenerPorcentajeDia(
                DateTime.parse(lista[i].fecha!).weekday - 1,
                lista[i].monto!))));
  }
  return AppointmentDataSource(appointments);
}

Widget historial(
    {required GastoProvider provider,
    required Appointment appointment,
    required CalendarAppointmentDetails calendar,
    required BuildContext context,
    required Future<void> Function() fun}) {
  return bd.Badge(
      badgeAnimation: bd.BadgeAnimation.fade(),
      badgeStyle: bd.BadgeStyle(badgeColor: ThemaMain.second),
      badgeContent:
          Icon(LineIcons.imageFile, size: 18.sp, color: ThemaMain.green),
      position: bd.BadgePosition.topEnd(end: -3, top: -3),
      showBadge: int.tryParse(appointment.location ?? "0") != 0,
      child: InkWell(
          onTap: () async {
            final modelado = await GastosController.find(
                int.parse(appointment.id.toString()), null);
            if (modelado != null) {
              showDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (context) =>
                          DialogHistorialPago(gasto: modelado))
                  .then((value) => fun());
            } else {
              showToast("Esta venta ya no existe");
            }
          },
          child: Container(
              padding: EdgeInsets.all(6.sp),
              decoration: BoxDecoration(
                  color: appointment.color,
                  borderRadius: BorderRadius.circular(borderRadius)),
              width: calendar.bounds.width,
              height: calendar.bounds.height,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${appointment.id}.- ${appointment.subject}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16.sp, color: ThemaMain.second)),
                    SubstringHighlight(
                        text:
                            "${Textos.fechaHMS(fecha: appointment.startTime)} - Metodo de pago: ${provider.metodo.firstWhereOrNull((element) => element.id == int.parse(appointment.notes!))?.nombre ?? "Desconocido"}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        term: provider.metodo
                                .firstWhereOrNull((element) =>
                                    element.id == int.parse(appointment.notes!))
                                ?.nombre ??
                            "Desconocido",
                        textStyle: TextStyle(
                            fontSize: (16).sp,
                            color: ThemaMain.second,
                            fontWeight: FontWeight.bold),
                        textStyleHighlight: TextStyle(
                            background: Paint(),
                            color: provider.metodo
                                    .firstWhereOrNull((element) =>
                                        element.id ==
                                        int.parse(appointment.notes!))
                                    ?.color ??
                                ThemaMain.second,
                            fontSize: (16).sp,
                            fontWeight: FontWeight.bold))
                  ]))));
}
