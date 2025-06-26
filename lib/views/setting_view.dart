import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastos/controllers/presupuesto_controller.dart';
import 'package:gastos/dialog/dialog_dropbox.dart';
import 'package:gastos/dialog/dialog_setting_notificaciones.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:gastos/widgets/addMobile/banner.dart';
import 'package:gastos/widgets/widget_settings/setting_metodo_pago.dart';
import 'package:gastos/widgets/widget_settings/settings_rango.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../utilities/preferences.dart';
import '../widgets/widget_settings/setting_backup.dart';
import '../widgets/widget_settings/setting_calidad_imagen.dart';
import '../widgets/widget_settings/setting_presupuesto_widget.dart';
import '../widgets/widget_settings/settings_bidones.dart';

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
                toolbarHeight: 6.h,
                title: Text("Opciones", style: TextStyle(fontSize: 18.sp)),
                actions: [
                  OverflowBar(spacing: 1.w, children: [
                    ElevatedButton.icon(
                        icon: Icon(
                            Preferences.thema ? LineIcons.sun : LineIcons.moon,
                            size: 20.sp),
                        onPressed: () => Dialogs.showMorph(
                            title: "Cambiar tema",
                            description:
                                "La aplicacion requerira un reinicio para aplicar este cambio",
                            loadingTitle: "Saliendo",
                            onAcceptPressed: (context) async {
                              setState(() {
                                Preferences.thema = !Preferences.thema;
                              });
                              await SystemNavigator.pop();
                            }),
                        label: Text("Tema", style: TextStyle(fontSize: 14.sp))),
                    IconButton.filled(
                        iconSize: 22.sp,
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) =>
                                DialogSettingNotificaciones()),
                        icon: Icon(LineIcons.bell, color: ThemaMain.yellow)),
                    IconButton.filled(
                        iconSize: 22.sp,
                        onPressed: () async => showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => DialogDropbox()),
                        icon: Icon(LineIcons.dropbox,
                            color: Preferences.tokenDropbox == ""
                                ? ThemaMain.red
                                : ThemaMain.green))
                  ])
                ]),
            body: SizedBox(
                height: 80.h,
                child: SafeArea(
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              BannerExample(tipo: 0),
                              const SettingMetodoPago(),
                              const Divider(),
                              SettingsBidones(),
                              BannerExample(tipo: 0),
                              const SettingCalidadImagen(),
                              const Divider(),
                              const SettingsRango(),
                              const Divider(),
                              SettingPresupuestoWidget(provider: provider),
                              Divider(),
                              const BackupManual()
                            ]))))),
            floatingActionButton: BannerExample(tipo: 1)));
  }
}
