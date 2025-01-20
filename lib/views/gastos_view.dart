import 'package:gastos/utilities/apis/rutas_app.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:gastos/widgets/addMobile/banner.dart';
import 'package:gastos/widgets/button_promedio_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widgets/card_gasto_widget.dart';
import '../widgets/widget_settings/historial_semanal_widget.dart';

class GastosView extends StatelessWidget {
  const GastosView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text('Gastos',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            actions: [
              Column(children: [
                OverflowBar(spacing: 1.w, children: [
                  const ButtonPromedioWidget(),
                  IconButton(
                      onPressed: () async =>
                          await Navigation.pushNamed(route: AppRoutes.opciones),
                      icon: Icon(Icons.settings,
                          size: 24.sp, color: Colors.white))
                ])
              ])
            ]),
        body: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Stack(children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                      height: 28.h,
                      child: SingleChildScrollView(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
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
                  child: CardGastoWidget(provider: provider))
            ])));
  }
}
