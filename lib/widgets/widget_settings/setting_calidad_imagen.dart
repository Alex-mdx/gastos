import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../utilities/preferences.dart';
import '../../utilities/services/dialog_services.dart';

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
      SfSlider(
          min: 50.0,
          max: 100.0,
          value: valorTemp,
          interval: 5,
          showTicks: true,
          showLabels: true,
          enableTooltip: true,
          stepSize: 5,
          minorTicksPerInterval: 1,
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
            } else {
              setState(() {
                Preferences.calidadFoto = value;
              });
            }
          },
          onChanged: (dynamic value) {
            setState(() {
              valorTemp = value;
            });
          })
    ]);
  }
}
