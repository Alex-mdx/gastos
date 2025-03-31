import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DialogBidones extends StatefulWidget {
  const DialogBidones({super.key});

  @override
  State<DialogBidones> createState() => _DialogBidonesState();
}

class _DialogBidonesState extends State<DialogBidones> {
  List<DateTime> fechas = [];
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("Bidones de Presupuesto",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
      Divider(height: 1.h),
      Padding(
          padding: EdgeInsets.all(8.sp),
          child: Card(
              child: Column(children: [
            TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "Nombre del bidon")),
            ElevatedButton.icon(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => CalendarDatePicker2(
                        config: CalendarDatePicker2Config(
                            calendarType: CalendarDatePicker2Type.range),
                        value: fechas,
                        onValueChanged: (dates) {})),
                label:
                    Text("Rango de Fechas", style: TextStyle(fontSize: 16.sp)),
                icon: Icon(Icons.calendar_month, size: 20.sp)),
            TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                decoration: InputDecoration(hintText: "\$ Monto Inicial")),
            TextButton(
                onPressed: () {},
                child: Text("Crear",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)))
          ])))
    ]));
  }
}
