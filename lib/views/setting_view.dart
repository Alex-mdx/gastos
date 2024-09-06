import 'package:flutter/material.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:sizer/sizer.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
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
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            Slider(
                activeColor: LightThemeColors.primary,
                inactiveColor: LightThemeColors.darkBlue,
                label: Preferences.calidadFoto.toStringAsFixed(0),
                value: Preferences.calidadFoto,
                onChanged: (value) {
                  if (value >= 35 && value <= 75) {
                    setState(() {
                      Preferences.calidadFoto = value;
                    });
                  }
                },
                divisions: 20,
                min: 0,
                max: 100)
          ]),
        ))));
  }
}
