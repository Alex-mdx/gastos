import 'package:flutter/material.dart';
import 'package:gastos/models/bidones_model.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

class ListBidonesWidget extends StatelessWidget {
  final BidonesModel bidon;
  final Function(int) delete;
  const ListBidonesWidget({super.key, required this.bidon, required this.delete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(LineIcons.vial, size: 24.sp),
        title: Text(
            "Apertura: ${Textos.fechaYMDHMS(fecha: bidon.fechaInicio)}\nCierre: ${Textos.fechaYMDHMS(fecha: bidon.fechaFinal)}",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        subtitle: Text(
            "Monto inicial: \$${Textos.moneda(moneda: bidon.montoInicial)}\nMonto corte: \$${Textos.moneda(moneda: bidon.montoFinal)}",
            style: TextStyle(fontSize: 14.sp)),
        trailing: IconButton(
            onPressed: () => delete(bidon.id!),
            icon:
                Icon(Icons.delete_sweep, size: 20.sp, color: ThemaMain.pink)));
  }
}
