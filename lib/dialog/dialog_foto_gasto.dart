import 'dart:typed_data';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
              Text('Archivo de evidencia',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              const Divider(),
              provider.imagenesActual.isEmpty
                  ? Center(
                      child: Text(
                          "No ha ingresado ninguna evidencia fotografica",
                          style: TextStyle(fontSize: 15.sp),
                          textAlign: TextAlign.center))
                  : Wrap(
                      children: provider.imagenesActual
                          .map((e) => Stack(
                              children: [iconEvidencia(context, e, provider)]))
                          .toList())
            ])));
  }

  IconButton iconEvidencia(
      BuildContext context, Uint8List e, GastoProvider provider) {
    return IconButton(
        icon: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.memory(e,
                fit: BoxFit.cover,
                height: 26.sp,
                width: 26.sp,
                filterQuality: FilterQuality.low)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => Column(children: [
                    Expanded(
                        child: PhotoView.customChild(
                            minScale: PhotoViewComputedScale.contained,
                            maxScale: PhotoViewComputedScale.contained * 2,
                            child: Image.memory(e))),
                    OverflowBar(
                        alignment: MainAxisAlignment.spaceAround,
                        overflowSpacing: 1.h,
                        children: [
                          IconButton(
                              iconSize: 24.sp,
                              onPressed: () {
                                Dialogs.showMorph(
                                    title: "Eliminar",
                                    description:
                                        '¿Desea eliminar esta foto seleccionada?',
                                    loadingTitle: 'Eliminando',
                                    onAcceptPressed: (context) async {
                                      provider.imagenesActual.remove(e);
                                      final tempModel = provider.gastoActual
                                          .copyWith(
                                              evidencia:
                                                  provider.imagenesActual);
                                      provider.gastoActual = tempModel;
                                      Navigation.pop();
                                    });
                              },
                              icon:
                                  const Icon(Icons.delete, color: Colors.red)),
                          IconButton(
                              iconSize: 24.sp,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProImageEditor.memory(e, callbacks:
                                                ProImageEditorCallbacks(
                                                    onImageEditingComplete:
                                                        (Uint8List
                                                            bytes) async {
                                              await Dialogs.showMorph(
                                                  title: "Guardar imagen",
                                                  description:
                                                      "¿Esta seguro de guardar esta imagen?\nReemplazara la imagen original por esta edicion",
                                                  loadingTitle: "Guardando",
                                                  onAcceptPressed:
                                                      (context) async {
                                                    int index = provider
                                                        .imagenesActual
                                                        .indexWhere((element) =>
                                                            element == e);
                                                    provider.imagenesActual[
                                                        index] = bytes;
                                                    Navigation.popTwice();
                                                    showToast(
                                                        "Salga y vuelva a entrar para que se efectuen los cambios");
                                                  });
                                            }))));
                              },
                              icon: Icon(Icons.edit))
                        ])
                  ]));
        });
  }
}
