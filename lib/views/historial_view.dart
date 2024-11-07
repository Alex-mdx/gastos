import 'package:flutter/material.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../dialog/s_dialog_historial_pago.dart';

class HistorialView extends StatefulWidget {
  const HistorialView({super.key});

  @override
  State<HistorialView> createState() => _HistorialViewState();
}

class _HistorialViewState extends State<HistorialView> {
  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Scaffold(
        appBar:
            AppBar(title: Text("Historial", style: TextStyle(fontSize: 20.sp))),
        body: SfCalendar(
            view: CalendarView.month,
            showDatePickerButton: true,
            showNavigationArrow: true,
            showTodayButton: true,
            initialSelectedDate: now,
            viewNavigationMode: ViewNavigationMode.snap,
            dataSource: _getCalendarDataSource(provider: provider),
            viewHeaderHeight: 2.h,
            showCurrentTimeIndicator: true,
            headerHeight: 4.h,
            allowAppointmentResize: true,
            appointmentBuilder: (context, calendarAppointmentDetails) {
              final Appointment appointment =
                  calendarAppointmentDetails.appointments.first;
              print("data ${appointment.id}");
              return InkWell(
                  onTap: () async {
                    final modelado = await GastosController.find(
                        int.parse(appointment.id.toString()));
                    if (modelado != null) {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              DialogHistorialPago(gasto: modelado));
                    } else {
                      showToast("Esta venta ya no existe");
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: appointment.color,
                          borderRadius: BorderRadius.circular(borderRadius)),
                      width: calendarAppointmentDetails.bounds.width,
                      height: calendarAppointmentDetails.bounds.height,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${appointment.id}.- ${appointment.subject}"),
                          Text(
                              provider.convertirHora(
                                  fecha: appointment.startTime),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                        ],
                      )));
            },
            monthViewSettings: const MonthViewSettings(
                showAgenda: true, numberOfWeeksInView: 5),
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
    {required GastoProvider provider}) {
  List<Appointment> appointments = <Appointment>[];
  for (var i = 0; i < provider.listaGastos.length; i++) {
    appointments.add(Appointment(
        id: provider.listaGastos[i].id,
        startTime: DateTime.parse(provider.listaGastos[i].fecha!),
        endTime: DateTime.parse(provider.listaGastos[i].fecha!),
        isAllDay: false,
        subject:
            'Gasto: \$${provider.listaGastos[i].monto} - Categoria: ${provider.listaCategoria.firstWhereOrNull((element) => element.id == provider.listaGastos[i].categoriaId)?.nombre ?? "Sin Categoria"}',
        color: Colors.blue,
        notes: "ahdskashdakdh"));
  }

  return AppointmentDataSource(appointments);
}
