import 'package:flutter/material.dart';
import 'package:gastos/models/metodo_pago_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DialogMetodoPago extends StatelessWidget {
  const DialogMetodoPago({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("Configuracion de metodo de pago",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      Padding(
          padding: EdgeInsets.all(8.sp),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SingleChildScrollView(
              child: ListView.builder(
                  itemCount: provider.metodo.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    MetodoPagoModel metodo = provider.metodo[index];
                    return Column(children: [
                      ListTile(
                          leading: Icon(Icons.payment,
                              size: 18.sp, color: LightThemeColors.green),
                          title: Text(metodo.nombre,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              "\$${metodo.cambio} - ${metodo.denominacion}",
                              style: TextStyle(fontSize: 14.sp)),
                          trailing: Icon(Icons.edit,
                              size: 18.sp, color: LightThemeColors.primary)),
                      Divider(height: 0)
                    ]);
                  }),
            ),
            ElevatedButton.icon(
                icon: Icon(Icons.add_card, size: 20.sp),
                onPressed: () {},
                label: Text("Nuevo", style: TextStyle(fontSize: 14.sp)))
          ]))
    ]));
  }
}
