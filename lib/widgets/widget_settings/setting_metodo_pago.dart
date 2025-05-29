import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../dialog/dialog_metodo_pago.dart';

class SettingMetodoPago extends StatefulWidget {
  const SettingMetodoPago({super.key});

  @override
  State<SettingMetodoPago> createState() => _SettingMetodoPagoState();
}

class _SettingMetodoPagoState extends State<SettingMetodoPago> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Column(children: [
      Text("Metodo de pago",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      OverflowBar(children: [
        Text(
            "Por defecto: ${provider.metodo.firstWhereOrNull((element) => element.id == 1)?.nombre ?? "Error"}",
            style: TextStyle(fontSize: 16.sp)),
        IconButton.filled(
            iconSize: 20.sp,
            onPressed: () => showDialog(
                context: context, builder: (context) => DialogMetodoPago(tipo: false)),
            icon: Icon(Icons.more_horiz, color: ThemaMain.green))
      ])
    ]);
  }
}
