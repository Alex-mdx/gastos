import 'package:flutter/material.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/dialog/dialog_metodo_pago_crear.dart';
import 'package:gastos/models/metodo_pago_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:substring_highlight/substring_highlight.dart';

class DialogMetodoPago extends StatelessWidget {
  final bool tipo;
  final MetodoPagoModel? metodoSelect;
  final Function(MetodoPagoModel) fun;
  const DialogMetodoPago(
      {super.key, required this.tipo, this.metodoSelect, required this.fun});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("${tipo ? "Seleccion" : "Configuracion"} de metodo de pago",
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
                            selectedTileColor: tipo ? ThemaMain.grey : null,
                            onTap: () {
                              if (tipo) {
                                fun(metodo);
                                // provider.metodoSelect = metodo;
                                Navigation.pop();
                              }
                            },
                            selected: tipo
                                ? metodoSelect?.id == metodo.id
                                : metodo.defecto == 1,
                            dense: tipo
                                ? metodoSelect?.id == metodo.id
                                : metodo.defecto == 1,
                            leading: Icon(metodoSelect?.icon ?? Icons.payment,
                                size: 20.sp,
                                color: tipo
                                    ? metodoSelect?.id == metodo.id
                                        ? ThemaMain.green
                                        : ThemaMain.darkBlue
                                    : metodo.defecto == 1
                                        ? ThemaMain.green
                                        : ThemaMain.darkBlue),
                            title: SubstringHighlight(
                                text:
                                    "${metodo.nombre}${tipo ? "" : " - Color"}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                term: "Color",
                                textStyle: TextStyle(
                                    fontSize: (14).sp,
                                    color: ThemaMain.darkBlue,
                                    fontWeight: FontWeight.bold),
                                textStyleHighlight: TextStyle(
                                    color: metodo.color,
                                    fontSize: (14).sp,
                                    fontWeight: FontWeight.bold)),
                            subtitle: !tipo
                                ? Text(
                                    "\$${metodo.cambio} - ${metodo.denominacion}",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: ThemaMain.darkBlue))
                                : null,
                            trailing: metodo.defecto == 0
                                ? OverflowBar(children: [
                                    IconButton(
                                        iconSize: 20.sp,
                                        onPressed: () => showDialog(
                                            context: context,
                                            builder: (context) =>
                                                DialogMetodoPagoCrear(
                                                    metodo: metodo)),
                                        icon: Icon(Icons.edit,
                                            color: ThemaMain.primary)),
                                    IconButton(
                                        iconSize: 20.sp,
                                        onPressed: () {
                                          Dialogs.showMorph(
                                              title: "Eliminar",
                                              description:
                                                  "¿Esta seguro de eliminar este metodo de pago?",
                                              loadingTitle: "Eliminado",
                                              onAcceptPressed: (context) async {
                                                await MetodoGastoController
                                                    .delete(metodo);
                                                provider.metodo =
                                                    await MetodoGastoController
                                                        .getItems();
                                              });
                                        },
                                        icon: Icon(Icons.delete_outline,
                                            color: ThemaMain.red))
                                  ])
                                : null),
                        Divider(height: 0)
                      ]);
                    })),
            if (!tipo)
              ElevatedButton.icon(
                  icon: Icon(Icons.add_card, size: 20.sp),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) =>
                          DialogMetodoPagoCrear(metodo: null)),
                  label: Text("Nuevo", style: TextStyle(fontSize: 14.sp)))
          ]))
    ]));
  }
}
