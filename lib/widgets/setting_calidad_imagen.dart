import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utilities/preferences.dart';
import '../utilities/services/dialog_services.dart';
import '../utilities/theme/theme_color.dart';

class SettingCalidadImagen extends StatefulWidget {
  const SettingCalidadImagen({super.key});

  @override
  State<SettingCalidadImagen> createState() => _SettingCalidadImagenState();
}

class _SettingCalidadImagenState extends State<SettingCalidadImagen> {
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
    return Column(children: [
      Text("Calidad de guardado de imagen",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
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
          max: 100)
    ]);
  }
}
