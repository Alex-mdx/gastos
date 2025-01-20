import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/presupuesto_controller.dart';
import 'package:gastos/dialog/dialog_youtube.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:gastos/widgets/addMobile/banner.dart';
import 'package:gastos/widgets/widget_settings/setting_metodo_pago.dart';
import 'package:gastos/widgets/widget_settings/setting_primer_dia_widget.dart';
import 'package:gastos/widgets/widget_settings/settings_rango.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:sizer/sizer.dart';
import '../widgets/widget_settings/setting_backup.dart';
import '../widgets/widget_settings/setting_calidad_imagen.dart';
import '../widgets/widget_settings/setting_presupuesto_widget.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          if (provider.presupuesto?.activo == 1) {
            log("actualizo");
            await PresupuestoController.insert(provider.presupuesto!);
          }
          provider.presupuesto = await PresupuestoController.getItem();
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text("Opciones", style: TextStyle(fontSize: 18.sp)),
                actions: [
                  OverflowBar(children: [
                    if (kDebugMode)
                      ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => DialogYoutube(link: "d"));
                          },
                          label: Text("Tutorial",
                              style: TextStyle(fontSize: 14.sp)),
                          icon: Icon(LineIcons.youtube, size: 20.sp)),
                    if (kDebugMode)
                      IconButton.filled(
                          iconSize: 20.sp,
                          onPressed: () {},
                          icon: Stack(alignment: Alignment.center, children: [
                            Icon(LineIcons.dropbox, color: Colors.white),
                            RiveAnimatedIcon(
                                riveIcon: RiveIcon.reload2,
                                strokeWidth: 10,
                                loopAnimation: true,
                                color: LightThemeColors.primary,
                                height: 22.sp,
                                width: 22.sp)
                          ]))
                  ])
                ]),
            body: SizedBox(
                height: 80.h,
                child: SafeArea(
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              const SettingMetodoPago(),
                              BannerExample(tipo: 0),
                              const SettingCalidadImagen(),
                              const Divider(),
                              const SettingsRango(),
                              const Divider(),
                              const SettingPrimerDiaWidget(),
                              const Divider(),
                              BannerExample(tipo: 0),
                              SettingPresupuestoWidget(provider: provider),
                              Divider(),
                              const BackupManual(),
                            ]))))),
            floatingActionButton: BannerExample(tipo: 1)));
  }
}
