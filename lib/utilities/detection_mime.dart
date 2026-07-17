import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/utilities/generate_excel.dart';
import 'package:gastos/utilities/zip_funcion.dart';
import 'package:mime/mime.dart';

class DetectionMime {
  static Future<void> operacion(List<File> files) async {
    // Obtener el tipo MIME del archivo
    for (var file in files) {
      final mimeType = lookupMimeType(file.path);

      switch (mimeType) {
        case 'application/pdf':
          debugPrint('El archivo es un PDF.');
          // Procesar PDF
          break;

        case 'image/jpeg':
          debugPrint('Archivo de imagen restaurado por unZip: ${file.path}');
          // Procesar JPG
          break;

        case 'application/zip':
          debugPrint('El archivo es un ZIP genérico.');
          var descompreso = await ZipFuncion.unZip(file);
          await operacion(descompreso); //ojito con la recursividad

          break;
        case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
          debugPrint("el archivo es un xlsx");
          await GenerateExcel.read(file);
          var fotos = await GastosController.getItemsOnlyEvidencia(null);
          await GastosController.base64tojpeg(gasto: fotos);
          break;

        default:
          debugPrint('Tipo de archivo desconocido: $mimeType');
        // Manejar otros casos
      }
    }
  }

  static String tipo(File file) {
    final mimeType = lookupMimeType(file.path);

    switch (mimeType) {
      case 'application/pdf':
        return "pdf";

      case 'image/jpeg':
        return "jpeg";

      case 'application/zip':
        return "zip";
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return "xlsx";

      default:
        return "Error";
    }
  }
}
