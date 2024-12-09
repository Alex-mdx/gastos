import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/controllers/presupuesto_controller.dart';
import 'package:gastos/dialog/dialog_youtube.dart';
import 'package:gastos/utilities/auth.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/generate_excel.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:gastos/widgets/addMobile/banner.dart';
import 'package:gastos/widgets/setting_presupuesto_widget.dart';
import 'package:gastos/widgets/setting_primer_dia_widget.dart';
import 'package:gastos/widgets/settings_rango.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:sizer/sizer.dart';

import '../widgets/setting_calidad_imagen.dart';

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
                              OverflowBar(
                                  overflowSpacing: .5.h,
                                  alignment: MainAxisAlignment.spaceAround,
                                  overflowAlignment:
                                      OverflowBarAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                        onPressed: () {
                                          Dialogs.showMorph(
                                              title: "Exportacion de datos",
                                              description:
                                                  "Se generara un respaldo de sus gastos a un archivo XLSX\nNota1: Evite modificar dicho archivo desde programas externos para evitar futuros errores\nNota2: Por el momento solo respalda los gatos ingresados y las categorias",
                                              loadingTitle: "Exportando",
                                              onAcceptPressed: (context) async {
                                                await GenerateExcel.backUp(
                                                    provider);
                                              });
                                        },
                                        label: Text("Exportacion datos",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold)),
                                        icon: Icon(LineIcons.fileUpload,
                                            size: 20.sp)),
                                    ElevatedButton.icon(
                                        onPressed: () {
                                          Dialogs.showMorph(
                                              title: "Importacion de datos",
                                              description:
                                                  "Ingrese un archivo de tipo XLSX para la importacion de sus datos\nNOTA: El archivo XSLX que seleccione debio ser generado desde la app de Control de Gastos, en caso de que haya sido manipulada y/o creado por programas externos podria corromper la importacion",
                                              loadingTitle: "Importando",
                                              loadingDescription:
                                                  "Es proceso podria tardar unos minutos en funcion a la cantidad de datos almacenados",
                                              onAcceptPressed: (context) async {
                                                await GenerateExcel.read(
                                                    provider);
                                                provider.listaGastos =
                                                    await GastosController
                                                        .getConfigurado();
                                                provider.listaCategoria =
                                                    await CategoriaController
                                                        .getItems();
                                              });
                                        },
                                        label: Text("Importar datos",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold)),
                                        icon: Icon(LineIcons.fileImport,
                                            size: 20.sp)),
                                    ElevatedButton.icon(
                                        onPressed: () async {
                                          Dialogs.showMorph(
                                              title: 'Eliminar datos',
                                              description:
                                                  "¿Esta seguro de eliminar sus datos?\nSe pedira acceso a sus datos biometricos para asegurar su identidad",
                                              loadingTitle: "Validando",
                                              onAcceptPressed: (context) async {
                                                final result =
                                                    await Auth.obtener();
                                                if (result) {
                                                  await GastosController
                                                      .deleteAll();

                                                  await CategoriaController
                                                      .deleteAll();
                                                  await PresupuestoController
                                                      .deleteAll();
                                                  provider.listaGastos.clear();
                                                  provider.listaCategoria
                                                      .clear();
                                                  provider.presupuesto = null;
                                                }
                                              });
                                        },
                                        label: Text("Eliminar datos",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold)),
                                        icon:
                                            Icon(LineIcons.trash, size: 18.sp))
                                  ]),
                              BannerExample(tipo: 0),
                              const SettingCalidadImagen(),
                              const Divider(),
                              const SettingsRango(),
                              const Divider(),
                              const SettingPrimerDiaWidget(),
                              const Divider(),
                              BannerExample(tipo: 0),
                              SettingPresupuestoWidget(provider: provider)
                            ]))))),
            floatingActionButton: BannerExample(tipo: 1)));
  }
}
