
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utilities/preferences.dart';
import '../utilities/theme/theme_app.dart';
import '../utilities/theme/theme_color.dart';

class SettingPrimerDiaWidget extends StatefulWidget {
  const SettingPrimerDiaWidget({super.key});

  @override
  State<SettingPrimerDiaWidget> createState() => _SettingPrimerDiaWidgetState();
}

class _SettingPrimerDiaWidgetState extends State<SettingPrimerDiaWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Primer dia de la semana",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: LightThemeColors.dialogbackground),
                child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Row(children: [
                      Text("Sabado", style: TextStyle(fontSize: 15.sp)),
                      Checkbox.adaptive(
                          value: Preferences.primerDia == 0,
                          onChanged: (value) {
                            setState(() {
                              Preferences.primerDia = 0;
                            });
                          })
                    ]))),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: LightThemeColors.dialogbackground),
                child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Row(children: [
                      Text("Domingo", style: TextStyle(fontSize: 15.sp)),
                      Checkbox.adaptive(
                          value: Preferences.primerDia == 1,
                          onChanged: (value) {
                            setState(() {
                              Preferences.primerDia = 1;
                            });
                          })
                    ]))),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: LightThemeColors.dialogbackground),
                child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Row(children: [
                      Text("Lunes", style: TextStyle(fontSize: 15.sp)),
                      Checkbox.adaptive(
                          value: Preferences.primerDia == 2,
                          onChanged: (value) {
                            setState(() {
                              Preferences.primerDia = 2;
                            });
                          })
                    ])))
          ]))
    ]);
  }
}
