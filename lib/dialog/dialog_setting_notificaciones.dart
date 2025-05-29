import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:sizer/sizer.dart';

class DialogSettingNotificaciones extends StatefulWidget {
  const DialogSettingNotificaciones({super.key});

  @override
  State<DialogSettingNotificaciones> createState() =>
      _DialogSettingNotificacionesState();
}

class _DialogSettingNotificacionesState
    extends State<DialogSettingNotificaciones> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Column(children: [
              Text("Configuraciones de notificaciones",
                  style: TextStyle(fontSize: 16.sp)),
              Divider(),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Column(children: [
                    Container(
                        decoration: BoxDecoration(
                            color: ThemaMain.white,
                            borderRadius: BorderRadius.circular(borderRadius)),
                        child: Padding(
                            padding: EdgeInsets.all(4.sp),
                            child: Row(children: [
                              Checkbox(value: false, onChanged: (value) {}),
                              TimePickerSpinner(
                                  is24HourMode: true,
                                  normalTextStyle: TextStyle(
                                      fontSize: 15.sp,
                                      color: ThemaMain.primary),
                                  highlightedTextStyle: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ThemaMain.darkBlue),
                                  spacing: 50,
                                  itemHeight: 80,
                                  isForce2Digits: true,
                                  onTimeChange: (time) {
                                    setState(() {});
                                  })
                            ])))
                  ]))
            ])));
  }
}
