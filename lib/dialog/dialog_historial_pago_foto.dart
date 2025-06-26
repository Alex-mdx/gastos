import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

import '../controllers/gastos_controller.dart';
import '../utilities/theme/theme_color.dart';

class DialogHistorialPagoFoto extends StatefulWidget {
  final File? file;
  final int idGasto;
  const DialogHistorialPagoFoto(
      {super.key, required this.file, required this.idGasto});

  @override
  State<DialogHistorialPagoFoto> createState() =>
      _DialogHistorialPagoFotoState();
}

class _DialogHistorialPagoFotoState extends State<DialogHistorialPagoFoto> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: PhotoView.customChild(
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 2,
              child: widget.file == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          Text("Imagen no soportada|no encontrada",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ThemaMain.grey,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold)),
                          Icon(Icons.image_not_supported,
                              size: 48.sp, color: ThemaMain.yellow),
                          TextButton.icon(
                              onPressed: () async => await Dialogs.showMorph(
                                  title: "Repara esta evidencia",
                                  description:
                                      "Esta accion reparará solo la evidencia de este gato",
                                  loadingTitle: "Generando...",
                                  onAcceptPressed: (context) async {
                                    var fotos = await GastosController
                                        .getItemsOnlyEvidencia(widget.idGasto);
                                    await GastosController.base64tojpeg(
                                        gasto: fotos);
                                  }),
                              label: Text("Repara este evidencia",
                                  style: TextStyle(fontSize: 14.sp)),
                              icon: Icon(Icons.image_search_rounded,
                                  size: 20.sp)),
                          TextButton.icon(
                              onPressed: () async => await Dialogs.showMorph(
                                  title: "Repara todas las evidencias",
                                  description:
                                      "Esta accion intentará reparar todas las evidencias que detecte\ntomara mas tiempo",
                                  loadingTitle: "Generando...",
                                  onAcceptPressed: (context) async {
                                    var fotos = await GastosController
                                        .getItemsOnlyEvidencia(null);
                                    await GastosController.base64tojpeg(
                                        gasto: fotos);
                                    Navigation.popTwice();
                                  }),
                              label: Text("Reparar todo",
                                  style: TextStyle(fontSize: 14.sp)),
                              icon:
                                  Icon(Icons.broken_image_rounded, size: 20.sp))
                        ])
                  : Image.file(widget.file!,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image, size: 30.sp),
                      fit: BoxFit.contain))),
      IconButton(
          onPressed: () => Navigation.pop(),
          icon: Icon(Icons.arrow_back_ios, size: 20.sp))
    ]);
  }
}
