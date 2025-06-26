import 'package:flutter/material.dart';
import 'package:gastos/widgets/addMobile/banner.dart';
import 'package:sizer/sizer.dart';

import '../widgets/graficos/grafico_categorias.dart';

class GraficosView extends StatelessWidget {
  const GraficosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
