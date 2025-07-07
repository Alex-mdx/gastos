import 'package:flutter/material.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/bidones_controller.dart';
import '../../dialog/dialog_bidones.dart';
import '../../utilities/operacion_bidon.dart';
import '../../utilities/theme/theme_app.dart';
import '../../utilities/theme/theme_color.dart';
import 'package:badges/badges.dart' as bd;

class SettingsBidones extends StatefulWidget {
  const SettingsBidones({super.key});

  @override
  State<SettingsBidones> createState() => _SettingsBidonesState();
}

class _SettingsBidonesState extends State<SettingsBidones> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Bidones de presupuesto",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      SizedBox(
          width: double.infinity,
          child: Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: FutureBuilder(
                      future: BidonesController.getItemsByAbierto(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!.isNotEmpty
                              ? Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.spaceAround,
                                  spacing: 1.w,
                                  children: snapshot.data!
                                      .map((bidones) => bd.Badge(
                                            onTap: () => Dialogs.showMorph(
                                                title: "Actualizar bidon",
                                                description:
                                                    "Se va a actualizar los datos del bidon",
                                                loadingTitle: "Actualizando",
                                                onAcceptPressed:
                                                    (context) async {
                                                  await OperacionBidon
                                                      .actualizar(
                                                          id: bidones.id);
                                                  setState(() {
                                                    showToast(
                                                        "Bidon actualizado");
                                                  });
                                                }),
                                            badgeStyle: bd.BadgeStyle(
                                                badgeColor: ThemaMain.primary),
                                            badgeContent: Icon(Icons.refresh,
                                                size: 18.sp,
                                                color: ThemaMain.white),
                                            position: bd.BadgePosition.topEnd(
                                                top: 0, end: -10),
                                            showBadge:
                                                bidones.gastos.isNotEmpty,
                                            badgeAnimation:
                                                bd.BadgeAnimation.slide(),
                                            child: Card(
                                              color: ThemaMain.dialogbackground,
                                              child: SizedBox(
                                                  width: 31.w,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () => showDialog(
                                                                context:
                                                                    context,
                                                                builder: (context) =>
                                                                    DialogBidones(
                                                                        bidon:
                                                                            bidones)),
                                                            child: Text(
                                                                "${bidones.nombre}\n${((bidones.montoFinal == 0 ? 0 : Textos.moneda(moneda: (((bidones.montoFinal) / bidones.montoInicial)) * 100, digito: 1)))}%\n\$${Textos.moneda(moneda: bidones.montoFinal)}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                        LinearProgressIndicator(
                                                            minHeight: 1.h,
                                                            valueColor: AlwaysStoppedAnimation(
                                                                bidones.inhabilitado ==
                                                                        0
                                                                    ? ThemaMain
                                                                        .darkBlue
                                                                    : ThemaMain
                                                                        .darkGrey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        borderRadius),
                                                            semanticsValue:
                                                                "${bidones.montoInicial}",
                                                            value: bidones
                                                                        .montoFinal ==
                                                                    0
                                                                ? 0
                                                                : ((bidones
                                                                        .montoFinal) /
                                                                    bidones
                                                                        .montoInicial))
                                                      ])),
                                            ),
                                          ))
                                      .toList())
                              : Center(
                                  child: Text("Sin bidones creados",
                                      style: TextStyle(fontSize: 16.sp)));
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}",
                              style: TextStyle(fontSize: 12.sp));
                        } else if (!snapshot.hasData) {
                          return Text("Sin bidones creados",
                              style: TextStyle(fontSize: 16.sp));
                        } else {
                          return CircularProgressIndicator();
                        }
                      })))),
      ElevatedButton(
          onPressed: () => showDialog(
              context: context, builder: (context) => DialogBidones()),
          child: Text("Crear",
              style: TextStyle(color: ThemaMain.green, fontSize: 16.sp)))
    ]);
  }
}
