import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:gastos/utilities/background.dart';
import 'package:gastos/utilities/notificaciones_fun.dart';
import 'package:gastos/utilities/permisos.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class DialogSettingNotificaciones extends StatefulWidget {
  const DialogSettingNotificaciones({super.key});

  @override
  State<DialogSettingNotificaciones> createState() =>
      _DialogSettingNotificacionesState();
}

class _DialogSettingNotificacionesState
    extends State<DialogSettingNotificaciones> {
  final now = DateTime.now();
  late bool act1;
  late bool act2;

  late DateTime hora1;
  late DateTime hora2;

  late String horaPreferencia1;
  late String horaPreferencia2;

  @override
  void initState() {
    super.initState();
    act1 = Preferences.recordatorioAct1;
    act2 = Preferences.recordatorioAct2;
    List<int> obj1 =
        Preferences.recordatorio1.split(":").map((e) => int.parse(e)).toList();
    List<int> obj2 =
        Preferences.recordatorio2.split(":").map((e) => int.parse(e)).toList();
    hora1 = DateTime(now.year, now.month, now.day, obj1[0], obj1[1], 0);
    hora2 = DateTime(now.year, now.month, now.day, obj2[0], obj2[1], 0);
    horaPreferencia1 = Textos.fechaHM(fecha: hora1);
    horaPreferencia2 = Textos.fechaHM(fecha: hora2);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Configuraciones de notificaciones (Beta)",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              Divider(),
              Text(
                  "Estas notificaciones se activaran todos los dias a la hora configurada",
                  style: TextStyle(fontSize: 14)),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Column(children: [
                    Container(
                        margin: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                            color: act1
                                ? ThemaMain.background
                                : ThemaMain.darkGrey,
                            borderRadius: BorderRadius.circular(borderRadius)),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                      value: act1,
                                      onChanged: (value) => setState(() {
                                            act1 = !act1;
                                          })),
                                  TimePickerSpinner(
                                      is24HourMode: true,
                                      normalTextStyle: TextStyle(
                                          fontSize: 15.sp,
                                          color: ThemaMain.primary),
                                      highlightedTextStyle: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ThemaMain.darkBlue),
                                      spacing: 2.w,
                                      time: hora1,
                                      itemHeight: 4.h,
                                      isForce2Digits: true,
                                      onTimeChange: (time) => setState(() {
                                            horaPreferencia1 =
                                                Textos.fechaHM(fecha: time);
                                            hora1 = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                time.hour,
                                                time.minute);
                                          }))
                                ]))),
                    Container(
                        margin: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                            color: act2
                                ? ThemaMain.background
                                : ThemaMain.darkGrey,
                            borderRadius: BorderRadius.circular(borderRadius)),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                      value: act2,
                                      onChanged: (value) => setState(() {
                                            act2 = !act2;
                                          })),
                                  TimePickerSpinner(
                                      is24HourMode: true,
                                      normalTextStyle: TextStyle(
                                          fontSize: 15.sp,
                                          color: ThemaMain.primary),
                                      highlightedTextStyle: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ThemaMain.darkBlue),
                                      spacing: 1.w,
                                      itemHeight: 4.h,
                                      time: hora2,
                                      isForce2Digits: true,
                                      onTimeChange: (time) => setState(() {
                                            horaPreferencia2 =
                                                Textos.fechaHM(fecha: time);
                                            hora2 = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                time.hour,
                                                time.minute);
                                          }))
                                ]))),
                    Divider(),
                    ElevatedButton(
                        onPressed: () => Dialogs.showMorph(
                            title: "Aplicar configuracion",
                            description:
                                "Se mantendra la configuracion ingresada",
                            loadingTitle:
                                "aplicacion configuracion de notificaciones",
                            onAcceptPressed: (context) async {
                              int id1 = 20;
                              int id2 = 30;
                              var result = await Permisos.notificacion();
                              if (result) {
                                await Background.cancelBackgroundTask(
                                    "task_$id1");
                                await Background.cancelBackgroundTask(
                                    "task_$id2");
                                Preferences.recordatorioAct1 = act1;
                                Preferences.recordatorioAct2 = act2;
                                Preferences.recordatorio1 = horaPreferencia1;
                                Preferences.recordatorio2 = horaPreferencia2;
                                if (act1) {
                                  await Background.scheduleDailyBackgroundTask(
                                      hour: hora1.hour,
                                      minute: hora1.minute,
                                      taskId: "task_$id1",
                                      taskFunction: () async =>
                                          await NotificacionesFun.show(id1));
                                }
                                if (act2) {
                                  await Background.scheduleDailyBackgroundTask(
                                      hour: hora2.hour,
                                      minute: hora2.minute,
                                      taskId: "task_$id2",
                                      taskFunction: () async =>
                                          await NotificacionesFun.show(id2));
                                }
                                await Permission.ignoreBatteryOptimizations
                                    .request();
                                    
                              } else {
                                showToast(
                                    "No tiene los permisos para habilitar las notificaciones");
                              }
                            }),
                        child:
                            Text("Aplicar", style: TextStyle(fontSize: 15.sp)))
                  ]))
            ])));
  }
}

