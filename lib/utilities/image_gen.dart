import 'dart:developer';
import 'dart:io';

import 'package:gastos/controllers/gastos_controller.dart';
import 'package:path_provider/path_provider.dart';

class ImageGen {
  static Future<void> generarImagen() async {
    try {
      var nuevo = await GastosController.getItemsOnlyEvidencia();
      log("${nuevo.length}");
      final direccion = await getDownloadsDirectory();
      for (var element in nuevo) {
        for (var imageBytes in element.evidencia) {
          final filePath = "${direccion!.path}/gasto_${element.id}.jpg";
          final file = File(filePath);
          await file.writeAsBytes(imageBytes);
        }
      }
    } catch (e) {
      print("Error al guardar la imagen: $e");
    }
  }

  static Future<List<File>> obtenerImagenesEvidencia() async {
    List<File> gasto = [];
    final directory = await getDownloadsDirectory();
    final files = directory?.listSync();
    for (var element in files!) {
      if (element.path.contains("gasto_")) {
        gasto.add(File(element.path));
      }
    }
    return gasto;
  }

}
