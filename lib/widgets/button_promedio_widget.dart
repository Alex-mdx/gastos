import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../utilities/preferences.dart';

class ButtonPromedioWidget extends StatefulWidget {
  const ButtonPromedioWidget({super.key});

  @override
  State<ButtonPromedioWidget> createState() => _ButtonPromedioWidgetState();
}

class _ButtonPromedioWidgetState extends State<ButtonPromedioWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GastoProvider>(builder: (context, provider, child) {
      return ElevatedButton.icon(
          onPressed: () {
            setState(() {
              Preferences.promedio = !Preferences.promedio;
            });
            setState(() {
              provider.promedioTotalSemana();
            });
          },
          icon: Icon(
              Preferences.promedio
                  ? LineIcons.calendarWithWeekFocus
                  : LineIcons.calendarMinusAlt,
              size: 20.sp),
          label: Text(!Preferences.promedio ? "Promedio" : "Semana",
              style: TextStyle(fontSize: 14.sp)));
    });
  }
}
