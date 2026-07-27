import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:sizer/sizer.dart';

class DialogWeekPicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onChanged;
  const DialogWeekPicker(
      {super.key, this.initialDate, required this.onChanged});

  @override
  State<DialogWeekPicker> createState() => _DialogWeekPickerState();
}

class _DialogWeekPickerState extends State<DialogWeekPicker> {
  late DateTime _selectedDate;
  final DateTime _firstDate = DateTime(2020);

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    int numeroSemana = Textos.getNumeroSemana(_selectedDate);

    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text('Seleccione la semana\nSemana $numeroSemana',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold))),
      WeekPicker(
          selectedDate: _selectedDate,
          onChanged: (DatePeriod newPeriod) {
            setState(() {
              _selectedDate = newPeriod.start;
            });
          },
          datePickerStyles: DatePickerRangeStyles(
              selectedPeriodStartDecoration: BoxDecoration(
                  color: ThemaMain.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              selectedPeriodLastDecoration: BoxDecoration(
                  color: ThemaMain.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              selectedSingleDateDecoration: BoxDecoration(
                  color: ThemaMain.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              currentDateStyle: TextStyle(
                  color: ThemaMain.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp),
              selectedDateStyle:
                  TextStyle(color: ThemaMain.second, fontSize: 16.sp)),
          firstDate: _firstDate,
          lastDate: DateTime.now()),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        TextButton(
            onPressed: () => Navigation.pop(), child: const Text('Cancelar')),
        ElevatedButton(
            onPressed: () {
              DateTime baseDate = widget.initialDate ?? DateTime.now();
              // Calculamos la diferencia de días respecto al inicio del rango/semana
              // o ajustamos _selectedDate (que es el inicio de semana/periodo) al mismo día de la semana de baseDate.
              int targetWeekday = baseDate.weekday;
              int currentWeekday = _selectedDate.weekday;
              int difference = targetWeekday - currentWeekday;
              DateTime resultDate =
                  _selectedDate.add(Duration(days: difference));

              widget.onChanged(resultDate);
              Navigation.pop();
            },
            child: const Text('Aceptar'))
      ])
    ]));
  }
}
