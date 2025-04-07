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
            Wrap(
                spacing: .5.w,
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.spaceAround,
                children: [
                  ChoiceChip.elevated(
                      label: Text("Lunes", style: TextStyle(fontSize: 14.sp)),
                      selected: false),
                  ChoiceChip.elevated(
                      label: Text("Martes", style: TextStyle(fontSize: 14.sp)),
                      selected: false),
                  ChoiceChip.elevated(
                      label:
                          Text("Miercoles", style: TextStyle(fontSize: 14.sp)),
                      selected: false),
                  ChoiceChip.elevated(
                      label: Text("Jueves", style: TextStyle(fontSize: 14.sp)),
                      selected: false),
                  ChoiceChip.elevated(
                      label: Text("Viernes", style: TextStyle(fontSize: 14.sp)),
                      selected: false),
                  ChoiceChip.elevated(
                      label: Text("Sabado", style: TextStyle(fontSize: 14.sp)),
                      selected: false),
                  ChoiceChip.elevated(
                      label: Text("Domingo", style: TextStyle(fontSize: 14.sp)),
                      selected: false)
                ]),
            TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                decoration: InputDecoration(hintText: "\$Monto Inicial")),
            ElevatedButton.icon(
                icon: Icon(Icons.group_work, size: 18.sp),
                onPressed: () {},
                label: Text("Crear",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)))
          ])))
    ]));
  }
}
