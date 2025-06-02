import 'package:gastos/utilities/apis/rutas_app.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/notificaciones_fun.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:gastos/widgets/addMobile/banner.dart';
import 'package:gastos/widgets/button_promedio_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../dialog/dialog_galeria.dart';
import '../widgets/card_gasto_widget.dart';
import '../widgets/historial_semanal_widget.dart';

class GastosView extends StatelessWidget {
  const GastosView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 6.h,
            title: Text('Gastos',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            actions: [
              Column(children: [
                OverflowBar(spacing: 1.w, children: [
                  IconButton(
                      onPressed: () async {
                        await NotificacionesFun.show(1);
                      },
                      icon: Icon(Icons.precision_manufacturing_sharp)),
                  const ButtonPromedioWidget(),
                  IconButton(
                      iconSize: 24.sp,
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => DialogGaleria()),
                      icon: Icon(LineIcons.imagesAlt,
                          color: ThemaMain.second)),
                  IconButton(
                      iconSize: 24.sp,
                      onPressed: () async =>
                          await Navigation.pushNamed(route: AppRoutes.opciones),
                      icon:
                          Icon(Icons.settings, color: ThemaMain.second))
                ])
              ])
            ]),
        body: Stack(children: [
          Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                  height: 35.h,
                  child: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    HistorialSemanalWidget(provider: provider),
                    BannerExample(tipo: 0),
                    /* Column(children: [
                  const Divider(),
                    Text("Recomendacion de gasto para esta semana",
                        style: TextStyle(fontSize: 16.sp))
                  ]) */
                  ])))),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: CardGastoWidget(provider: provider)))
        ]));
  }
}
