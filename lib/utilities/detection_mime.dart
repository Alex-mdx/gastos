import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/utilities/generate_excel.dart';
import 'package:gastos/utilities/zip_funcion.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
          final direccion = await getDownloadsDirectory();
          // Obtener el nombre base del archivo con su extesnion
          String name = p.basename(file.path);
          // Crear la nueva ruta del archivo en la carpeta destino
          final filePath = "${direccion!.path}/$name";
          // Leer los bytes del archivo original
          var fileBytes = await file.readAsBytes();
          // Escribir los bytes en la nueva ubicación
          final newFile = File(filePath);
          await newFile.writeAsBytes(fileBytes);
          debugPrint('Archivo guardado en: $filePath');
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
          await GastosController.base64tojpeg();
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
        debugPrint('El archivo es un PDF.');
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
