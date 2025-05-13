import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/bidones_controller.dart';
import 'package:gastos/controllers/presupuesto_controller.dart';
import 'package:gastos/dialog/dialog_bidones.dart';
import 'package:gastos/dialog/dialog_dropbox.dart';
import 'package:gastos/dialog/dialog_youtube.dart';
import 'package:gastos/models/bidones_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:gastos/widgets/addMobile/banner.dart';
import 'package:gastos/widgets/widget_settings/setting_metodo_pago.dart';
import 'package:gastos/widgets/widget_settings/setting_primer_dia_widget.dart';
import 'package:gastos/widgets/widget_settings/settings_rango.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../utilities/preferences.dart';
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
                toolbarHeight: 6.h,
                title: Text("Opciones", style: TextStyle(fontSize: 18.sp)),
                actions: [
                  OverflowBar(children: [
                    if (kDebugMode)
                      ElevatedButton.icon(
                          onPressed: () async {
                            var tipo =
                                await BidonesController.getItemsByAbierto();
                          },
                          label: Text("Tutorial",
                              style: TextStyle(fontSize: 14.sp)),
                          icon: Icon(LineIcons.youtube, size: 20.sp)),
                    if (kDebugMode)
                      IconButton.filled(
                          iconSize: 24.sp,
                          onPressed: () async => showDialog(
                              context: context,
                              builder: (context) => DialogDropbox()),
                          icon: Stack(alignment: Alignment.center, children: [
                            Icon(LineIcons.dropbox,
                                color: Preferences.tokenDropbox == ""
                                    ? LightThemeColors.red
                                    : LightThemeColors.green),
                            /* RiveAnimatedIcon(
                                riveIcon: RiveIcon.reload2,
                                strokeWidth: 10,
                                loopAnimation: true,
                                color: Colors.white,
                                height: 26.sp,
                                width: 24.sp) */
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
                              BannerExample(tipo: 0),
                              const SettingMetodoPago(),
                              const Divider(),
                              Column(children: [
                                Text("Bidones de presupuesto",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: double.infinity,
                                  child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: EdgeInsets.all(8.sp),
                                          child: FutureBuilder(
                                              future: BidonesController
                                                  .getItemsByAbierto(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return snapshot
                                                          .data!.isNotEmpty
                                                      ? Wrap(
                                                          crossAxisAlignment:
                                                              WrapCrossAlignment
                                                                  .center,
                                                          alignment:
                                                              WrapAlignment
                                                                  .spaceAround,
                                                          spacing: 1.w,
                                                          children: snapshot
                                                              .data!
                                                              .map((bidones) =>
                                                                  SizedBox(
                                                                      width:
                                                                          31.w,
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .center,
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            TextButton(
                                                                                onPressed: () => showDialog(context: context, builder: (context) => DialogBidones(bidon: bidones)),
                                                                                child: Text("${bidones.nombre}\n${((bidones.montoFinal == 0 ? 0 : ((bidones.montoFinal) / bidones.montoInicial)) * 100)}% - \$${bidones.montoFinal}", textAlign: TextAlign.center, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold))),
                                                                            LinearProgressIndicator(
                                                                                minHeight: 1.h,
                                                                                valueColor: AlwaysStoppedAnimation(bidones.inhabilitado == 0 ? LightThemeColors.darkBlue : LightThemeColors.darkGrey),
                                                                                borderRadius: BorderRadius.circular(borderRadius),
                                                                                semanticsValue: "${bidones.montoInicial}",
                                                                                value: bidones.montoFinal == 0 ? 0 : ((bidones.montoFinal) / bidones.montoInicial))
                                                                          ])))
                                                              .toList())
                                                      : Center(
                                                          child: Text(
                                                              "Sin bidones creados",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.sp)),
                                                        );
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      "${snapshot.error}",
                                                      style: TextStyle(
                                                          fontSize: 12.sp));
                                                } else if (!snapshot.hasData) {
                                                  return Text(
                                                      "Sin bidones creados",
                                                      style: TextStyle(
                                                          fontSize: 16.sp));
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              }))),
                                ),
                                ElevatedButton(
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) => DialogBidones()),
                                    child: Text("Crear",
                                        style: TextStyle(
                                            color: LightThemeColors.green,
                                            fontSize: 16.sp)))
                              ]),
                              BannerExample(tipo: 0),
                              const SettingCalidadImagen(),
                              const Divider(),
                              const SettingsRango(),
                              const Divider(),
                              const SettingPrimerDiaWidget(),
                              BannerExample(tipo: 0),
                              SettingPresupuestoWidget(provider: provider),
                              Divider(),
                              const BackupManual()
                            ]))))),
            floatingActionButton: BannerExample(tipo: 1)));
  }
}
