import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../utilities/services/dialog_services.dart';

class DialogCamara extends StatefulWidget {
  const DialogCamara({super.key});

  @override
  State<DialogCamara> createState() => _DialogCamaraState();
}

class _DialogCamaraState extends State<DialogCamara> {
  IconButton iconEvidencia(
      BuildContext context, Uint8List e, GastoProvider provider) {
    return IconButton(
        icon: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.memory(e,
                fit: BoxFit.cover,
                height: 28.sp,
                width: 28.sp,
                filterQuality: FilterQuality.low)),
        onPressed: () => showDialog(
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
                            onPressed: () => Dialogs.showMorph(
                                title: "Eliminar",
                                description:
                                    '¿Desea eliminar esta foto seleccionada?',
                                loadingTitle: 'Eliminando',
                                onAcceptPressed: (context) async {
                                  setState(() {
                                    provider.imagenesActual.remove(e);
                                  });

                                  Navigation.pop();
                                }),
                            icon: const Icon(Icons.delete, color: Colors.red)),
                        IconButton(
                            iconSize: 24.sp,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProImageEditor.memory(
                                        e,
                                        callbacks: ProImageEditorCallbacks(
                                            onImageEditingComplete: (Uint8List
                                                    bytes) async =>
                                                Dialogs.showMorph(
                                                    title: "Guardar imagen",
                                                    description:
                                                        "¿Esta seguro de guardar esta imagen?\nReemplazara la imagen original por esta edicion",
                                                    loadingTitle: "Guardando",
                                                    onAcceptPressed:
                                                        (context) async {
                                                      int index = provider
                                                          .imagenesActual
                                                          .indexWhere(
                                                              (element) =>
                                                                  element == e);
                                                      setState(() {
                                                        provider.imagenesActual[
                                                            index] = bytes;
                                                      });

                                                      Navigation.popTwice();
                                                      showToast(
                                                          "Salga y vuelva a entrar para que se efectuen los cambios");
                                                    }))))),
                            icon: Icon(Icons.edit))
                      ])
                ])));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Ingresar evidencia', style: TextStyle(fontSize: 18.sp)),
              ElevatedButton.icon(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? photo = await picker.pickImage(
                        maxHeight: 1280,
                        maxWidth: 720,
                        imageQuality: Preferences.calidadFoto.toInt(),
                        source: ImageSource.camera,
                        requestFullMetadata: false);
                    if (photo != null) {
                      final data = await photo.readAsBytes();
                      setState(() {
                        provider.imagenesActual.add(data);
                      });
                    }
                  },
                  label: Text('Camara', style: TextStyle(fontSize: 16.sp)),
                  icon: Icon(Icons.camera_alt, size: 20.sp)),
              ElevatedButton.icon(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final List<XFile> images = await picker.pickMultiImage(
                        imageQuality: Preferences.calidadFoto.toInt(),
                        maxHeight: 1280,
                        maxWidth: 720,
                        limit: 10,
                        requestFullMetadata: false);
                    if (images.isNotEmpty) {
                      for (var element in images) {
                        final data = (await element.readAsBytes());
                        setState(() {
                          provider.imagenesActual.add(data);
                        });
                      }
                    }
                  },
                  label: Text('Galeria', style: TextStyle(fontSize: 16.sp)),
                  icon: Icon(Icons.image_search, size: 20.sp)),
              Divider(),
              Column(mainAxisSize: MainAxisSize.min, children: [
                provider.imagenesActual.isEmpty
                    ? Center(
                        child: Text(
                            "No ha ingresado ninguna evidencia fotografica",
                            style: TextStyle(fontSize: 15.sp),
                            textAlign: TextAlign.center))
                    : Wrap(
                        children: provider.imagenesActual
                            .map((e) => Stack(children: [
                                  iconEvidencia(context, e, provider)
                                ]))
                            .toList())
              ])
            ])));
  }
}
