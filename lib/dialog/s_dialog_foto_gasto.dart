import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../utilities/services/navigation_services.dart';

class DialogFotoGasto extends StatelessWidget {
  const DialogFotoGasto({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Archivo de evidencia'),
              const Divider(),
              provider.imagenesActual.isEmpty
                  ? const Center(
                      child: Text(
                          "No ha ingresado ninguna evidencia fotografica",
                          textAlign: TextAlign.center))
                  : Wrap(
                      children: provider.imagenesActual
                          .map((e) => Stack(children: [
                                IconButton(
                                    icon: const Icon(Icons.image),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              Column(children: [
                                                Expanded(
                                                    child: PhotoView.customChild(
                                                        minScale:
                                                            PhotoViewComputedScale
                                                                .contained,
                                                        maxScale:
                                                            PhotoViewComputedScale
                                                                    .contained *
                                                                2,
                                                        child:
                                                            Image.memory(e))),
                                                IconButton(
                                                    onPressed: () {
                                                      Dialogs.showMorph(
                                                          title: "Eliminar",
                                                          description:
                                                              '¿Desea eliminar esta foto seleccionada?',
                                                          loadingTitle:
                                                              'Eliminando',
                                                          onAcceptPressed:
                                                              (context) async {
                                                            provider
                                                                .imagenesActual
                                                                .remove(e);
                                                            final tempModel = provider
                                                                .gastoActual
                                                                .copyWith(
                                                                    evidencia:
                                                                        provider
                                                                            .imagenesActual);
                                                            provider.gastoActual =
                                                                tempModel;
                                                            Navigation.pop();
                                                          });
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red))
                                              ]));
                                    })
                              ]))
                          .toList())
            ])));
  }
}
