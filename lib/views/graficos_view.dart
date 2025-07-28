import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/widgets/addMobile/banner.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widgets/graficos/grafico_categorias.dart';

class GraficosView extends StatelessWidget {
  const GraficosView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Scaffold(
        appBar: AppBar(
            leading: kDebugMode? IconButton(
                iconSize: 20.sp,
                onPressed: () =>
                  provider.sliderDrawerKey.currentState?.toggle(),
                icon: Icon(Icons.menu)) : null,
            toolbarHeight: 6.h,
            title: Text("Graficos", style: TextStyle(fontSize: 20.sp))),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              BannerExample(tipo: 1),
              GraficoCategorias(),
              BannerExample(tipo: 1)
            ])));
  }
}
