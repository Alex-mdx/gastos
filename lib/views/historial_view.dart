import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../dialog/dialog_historial_pago.dart';
import '../models/gasto_model.dart';

class HistorialView extends StatefulWidget {
  const HistorialView({super.key});

  @override
  State<HistorialView> createState() => _HistorialViewState();
}

class _HistorialViewState extends State<HistorialView> {
  @override
  void initState() {
    super.initState();
    calendar.displayDate = now.subtract(Duration(days: now.day - 1));
    calendar.selectedDate = now;
  }

  final now = DateTime.now();
  CalendarController calendar = CalendarController();
  List<GastoModelo> lista = [];

  Future<List<GastoModelo>> obtenerFechas() async {
    lista =
        await GastosController.obtenerFechasEnRangoMes(calendar.displayDate!);
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Scaffold(
        appBar:
            AppBar(title: Text("Historial", style: TextStyle(fontSize: 20.sp))),
        body: SfCalendar(
            view: CalendarView.month,
            showDatePickerButton: true,
            onViewChanged: (viewChangedDetails) {
              log("$calendar");
            },
            showNavigationArrow: true,
            showTodayButton: true,
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
                                    color: LightThemeColors.grey)
                                : null,
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(details.date.day.toString(),
                                    style: TextStyle(fontSize: 16.sp))))),
                    if (montoDay != 0)
                      Center(
                          child: Text(
                              "\$${provider.convertirNumero(moneda: montoDay)}",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)))
                  ]));
            },
            viewNavigationMode: ViewNavigationMode.snap,
            dataSource:
                _getCalendarDataSource(provider: provider, lista: lista),
            viewHeaderHeight: 2.h,
            controller: calendar,
            loadMoreWidgetBuilder: (context, loadMoreAppointments) {
              return FutureBuilder(
                  future: obtenerFechas(),
                  builder: (context, snapShot) {
                    print(snapShot);
                    if (!snapShot.hasData) {
                      return Container(
                          height: calendar.view == CalendarView.schedule
                              ? 50
                              : double.infinity,
                          width: double.infinity,
                          color: Colors.white38,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.deepPurple)));
                    } else {
                      return Visibility(visible: false, child: Text("test"));
                    }
                  });
            },
            firstDayOfWeek: Preferences.primerDia == 0
                ? 6
                : Preferences.primerDia == 1
                    ? 7
                    : 1,
            showCurrentTimeIndicator: true,
            headerHeight: 4.h,
            allowAppointmentResize: true,
            appointmentBuilder: (context, calendarAppointmentDetails) {
              final Appointment appointment =
                  calendarAppointmentDetails.appointments.first;
              return InkWell(
                  onTap: () async {
                    final modelado = await GastosController.find(
                        int.parse(appointment.id.toString()));
                    if (modelado != null) {
                      showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (context) =>
                              DialogHistorialPago(gasto: modelado));
                    } else {
                      showToast("Esta venta ya no existe");
                    }
                  },
                  child: Container(
                      padding: EdgeInsets.all(6.sp),
                      decoration: BoxDecoration(
                          color: appointment.color,
                          borderRadius: BorderRadius.circular(borderRadius)),
                      width: calendarAppointmentDetails.bounds.width,
                      height: calendarAppointmentDetails.bounds.height,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${appointment.id}.- ${appointment.subject}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16.sp)),
                            Text(
                                provider.convertirHora(
                                    fecha: appointment.startTime),
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold))
                          ])));
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
        subject:
            'Gasto: \$${lista[i].monto} - Categoria: ${provider.listaCategoria.firstWhereOrNull((element) => element.id == lista[i].categoriaId)?.nombre ?? "Sin Categoria"}',
        color: provider.presupuesto?.activo == 0 || provider.presupuesto == null
            ? LightThemeColors.primary
            : provider.porcentualColor(provider.obtenerPorcentajeDia(
                DateTime.parse(lista[i].fecha!).weekday - 1,
                lista[i].monto!))));
  }

  return AppointmentDataSource(appointments);
}
