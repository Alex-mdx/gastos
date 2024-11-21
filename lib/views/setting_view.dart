import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  List<String> rangos = ["Mensual", "Trimestral", "Semestral", "Anual"];
  SingleSelectController<String> controller =
      SingleSelectController(Preferences.calculo);
  double valorTemp = 75;
  @override
  void initState() {
    setState(() {
      valorTemp = Preferences.calidadFoto;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Opciones")),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text("Calidad de guardado de imagen",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      Slider(
                          activeColor: LightThemeColors.primary,
                          inactiveColor: LightThemeColors.darkBlue,
                          label: valorTemp.toStringAsFixed(0),
                          value: valorTemp,
                          onChangeEnd: (value) async {
                            if (value >= 90) {
                              await Dialogs.showMorph(
                                  title: "Imagen de muy alta calidad",
                                  description:
                                      "Guardar con una calidad alta, podria causar con el tiempo poca optimizacion al momento de calcular sus gastos",
                                  loadingTitle: "Efectuando",
                                  onAcceptPressed: (context) async {
                                    setState(() {
                                      Preferences.calidadFoto = value;
                                    });
                                  }).whenComplete(() {
                                setState(() {
                                  valorTemp = Preferences.calidadFoto;
                                });
                              });
                            } else if (value <= 60) {
                              await Dialogs.showMorph(
                                  title: "Imagen de muy baja calidad",
                                  description:
                                      "Guardar con una calidad baja, podria causar poca o nula comprensión en sus evidencias",
                                  loadingTitle: "Efectuando",
                                  onAcceptPressed: (context) async {
                                    setState(() {
                                      Preferences.calidadFoto = value;
                                    });
                                  }).whenComplete(() {
                                setState(() {
                                  valorTemp = Preferences.calidadFoto;
                                });
                              });
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              valorTemp = value;
                              if (value <= 85 && value >= 65) {
                                Preferences.calidadFoto = value;
                              }
                            });
                          },
                          divisions: 10,
                          min: 50,
                          max: 100),
                      Text("Primero dia de la semana",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(borderRadius),
                                        color:
                                            LightThemeColors.dialogbackground),
                                    child: Padding(
                                        padding: EdgeInsets.all(8.sp),
                                        child: Row(children: [
                                          Text("Sabado",
                                              style:
                                                  TextStyle(fontSize: 15.sp)),
                                          Checkbox.adaptive(
                                              value: Preferences.primerDia == 0,
                                              onChanged: (value) {
                                                setState(() {
                                                  Preferences.primerDia = 0;
                                                });
                                              }),
                                        ]))),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(borderRadius),
                                        color:
                                            LightThemeColors.dialogbackground),
                                    child: Padding(
                                        padding: EdgeInsets.all(8.sp),
                                        child: Row(children: [
                                          Text("Domingo",
                                              style:
                                                  TextStyle(fontSize: 15.sp)),
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
                                        borderRadius:
                                            BorderRadius.circular(borderRadius),
                                        color:
                                            LightThemeColors.dialogbackground),
                                    child: Padding(
                                        padding: EdgeInsets.all(8.sp),
                                        child: Row(children: [
                                          Text("Lunes",
                                              style:
                                                  TextStyle(fontSize: 15.sp)),
                                          Checkbox.adaptive(
                                              value: Preferences.primerDia == 2,
                                              onChanged: (value) {
                                                setState(() {
                                                  Preferences.primerDia = 2;
                                                });
                                              })
                                        ])))
                              ])),
                      Text("Rango de fecha maximo de calculo",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      CustomDropdown(
                          controller: controller,
                          decoration: CustomDropdownDecoration(
                              prefixIcon: Icon(LineIcons.calendarPlusAlt,
                                  color: LightThemeColors.green, size: 22.sp),
                              closedSuffixIcon: controller.value != null
                                  ? IconButton(
                                      iconSize: 22.sp,
                                      onPressed: () => setState(() {
                                            controller.clear();
                                          }),
                                      icon: Icon(Icons.close_rounded,
                                          size: 20.sp))
                                  : null),
                          headerBuilder: (context, selectedItem, enabled) =>
                              Text(selectedItem,
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold)),
                          hintText: 'Seleccione rango de calculo de gasto',
                          items: rangos,
                          listItemBuilder:
                              (context, item, isSelected, onItemSelect) => Text(
                                  item,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold)),
                          overlayHeight: 40.h,
                          onChanged: (value) {
                            if (value != null) {
                              print("$value");
                            }

                            log('changing value to: $value');
                          })
                    ])))));
  }
}
