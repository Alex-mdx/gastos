import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/models/categoria_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DialogCategorias extends StatelessWidget {
  const DialogCategorias({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController tipoGasto = TextEditingController();
    TextEditingController descripcion = TextEditingController();
    final provider = Provider.of<GastoProvider>(context);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Ingresar Tipo de Gasto',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          TextField(maxLines: 2,
              minLines: 1,
              controller: tipoGasto,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 1.w, vertical: 0),
                  hintText: 'Tipo de gasto')),
          const Divider(),
          TextField(
              controller: descripcion,
              maxLines: 6,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 1.w, vertical: 0),
                  hintText: 'Descripcion de tipo de gasto')),
          ElevatedButton(
              onPressed: () async {
                if (tipoGasto.text == "" || descripcion.text == "") {
                  showToast('Rellene todos los campos');
                } else {
                  await Dialogs.showMorph(
                      title: 'Tipo de gasto',
                      description: '¿Ingresar este tipo de gasto?',
                      loadingTitle: 'Ingresando...',
                      onAcceptPressed: (context) async {
                        var id = (await CategoriaController.getLastId());
                        log("${id + 1}");
                        CategoriaModel objeto = CategoriaModel(
                            id: id + 1,
                            nombre: tipoGasto.text,
                            descripcion: descripcion.text);
                        await CategoriaController.insert(objeto);
                        provider.listaCategoria =
                            await CategoriaController.getItems();
                        Navigation.pop();
                      });
                }
              },
              child: const Text('Ingresar'))
        ]));
  }
}
