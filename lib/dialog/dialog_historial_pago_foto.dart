import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

import '../utilities/theme/theme_color.dart';

class DialogHistorialPagoFoto extends StatefulWidget {
  final File? file;
  const DialogHistorialPagoFoto({super.key, required this.file});

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
                          Text("Imagen no soportada",
                              style: TextStyle(
                                  color: LightThemeColors.grey,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold)),
                          Icon(Icons.image_not_supported,
                              size: 42.sp, color: LightThemeColors.yellow),
                          TextButton.icon(
                              onPressed: () async => await Dialogs.showMorph(
                                  title: "Reparar imagen",
                                  description:
                                      "Esta accion intentara generar una imagen partiendo de la imagen corrupta",
                                  loadingTitle: "Generando",
                                  onAcceptPressed: (context) async {}),
                              label: Text("Reparar",
                                  style: TextStyle(fontSize: 14.sp)),
                              icon: Icon(Icons.image_search, size: 20.sp))
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
