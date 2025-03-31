import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';
import '../../utilities/preferences.dart';
import '../../utilities/theme/theme_color.dart';

class SettingsRango extends StatefulWidget {
  const SettingsRango({super.key});

  @override
  State<SettingsRango> createState() => _SettingsRangoState();
}

class _SettingsRangoState extends State<SettingsRango> {
  List<String> rangos = [
    "Mensual",
    "Bimestral",
    "Trimestral",
    "Semestral",
    "Anual"
  ];
  SingleSelectController<String> controller =
      SingleSelectController(Preferences.calculo);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Rango maximo para calculo de gasto",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      CustomDropdown(
          controller: controller,
          decoration: CustomDropdownDecoration(
              prefixIcon: Icon(LineIcons.calendarPlusAlt,
                  color: LightThemeColors.green, size: 22.sp)),
          headerBuilder: (context, selectedItem, enabled) {
            int rango =
                rangos.indexWhere((element) => element.contains(selectedItem));
            return Text(
                "$selectedItem\n${rango == 0 ? "${Textos.fechaYMD(fecha: DateTime.now().subtract(Duration(days: 31)))} - ${Textos.fechaYMD(fecha: DateTime.now())}" : rango == 1 ? "${Textos.fechaYMD(fecha: DateTime.now().subtract(Duration(days: 60)))} - ${Textos.fechaYMD(fecha: DateTime.now())}" : rango == 2 ? "${Textos.fechaYMD(fecha: DateTime.now().subtract(Duration(days: 91)))} - ${Textos.fechaYMD(fecha: DateTime.now())}" : rango == 3 ? "${Textos.fechaYMD(fecha: DateTime.now().subtract(Duration(days: 183)))} - ${Textos.fechaYMD(fecha: DateTime.now())}" : "${Textos.fechaYMD(fecha: DateTime.now().subtract(Duration(days: 365)))} - ${Textos.fechaYMD(fecha: DateTime.now())}"}",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold));
          },
          hintText: 'Seleccione rango de calculo de gasto',
          items: rangos,
          listItemBuilder: (context, item, isSelected, onItemSelect) => Text(
              item,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          overlayHeight: 40.h,
          onChanged: (value) async {
            if (value != null) {
              if (value == "Semestral" || value == "Anual") {
                showToast(
                    "La seleccion de $value puede estimular un análisis mas precisos de sus gastos, pero tambien puede alentar el sistema");
              }
              Preferences.calculo = value;
            }
          })
    ]);
  }
}
