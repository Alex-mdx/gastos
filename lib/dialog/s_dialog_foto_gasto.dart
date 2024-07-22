import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../utilities/services/navigation_services.dart';

class DialogFotoGasto extends StatefulWidget {
  const DialogFotoGasto({super.key});

  @override
  State<DialogFotoGasto> createState() => _DialogFotoGasto();
}

class _DialogFotoGasto extends State<DialogFotoGasto> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Archivo de evidencia'),
              Divider(),
              Wrap(
                  children: provider.imagenesActual
                      .map((e) => Stack(children: [
                            IconButton(
                                icon: Icon(Icons.image),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Column(children: [
                                            Expanded(
                                                child: PhotoView.customChild(
                                                    minScale:
                                                        PhotoViewComputedScale
                                                            .contained,
                                                    maxScale:
                                                        PhotoViewComputedScale
                                                                .contained *
                                                            2,
                                                    child: Image.memory(e))),
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
                                                        setState(() {
                                                          provider
                                                              .imagenesActual
                                                              .remove(e);
                                                        });

                                                        Navigation.pop();
                                                      });
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red))
                                          ]));
                                })
                          ]))
                      .toList())
            ])));
  }
}
