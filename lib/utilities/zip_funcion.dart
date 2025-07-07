import 'dart:io';

import 'package:archive/archive.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ZipFuncion {
  static Future<List<File>> unZip(File zip) async {
    try {
      List<File> archivos = [];
      final bytes = zip.readAsBytesSync();
      // Decodificar el archivo ZIP
      final archive = ZipDecoder().decodeBytes(bytes);
      final direccion = await getDownloadsDirectory();
      // Extraer los archivos en el directorio de salida
      for (final file in archive) {
        final fileName = file.name;
        final filePath = '${direccion!.path}/$fileName';

        if (file.isFile) {
          // Si es un archivo, crea y escribe los bytes
          final outFile = File(filePath);
          archivos.add(outFile);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        } else {
          // Si es un directorio, asegúrate de que exista
          await Directory(filePath).create(recursive: true);
        }
      }

      showToast('Descompresión completada');
      return archivos;
    } catch (e) {
      showToast('Error al descomprimir\n$e');
      return [];
    }
  }

  static Future<File?> toZip(List<File> archivos) async {
    // Crea un archivo ZIP vacío
    final archive = Archive();

    for (var imagePath in archivos) {
      final imageBytes = await imagePath.readAsBytes();
      String name = path.basename(imagePath.path);
      archive.addFile(ArchiveFile(name, imageBytes.length, imageBytes));
    }
    // Comprime el archivo ZIP
    final zipEncoder = ZipEncoder();
    final zipFileBytes = zipEncoder.encode(archive,level: 9);
    final direccion = await getDownloadsDirectory();
    // Guarda el archivo ZIP en el sistema de archivos
    final outputFile = File("${direccion!.path}/respaldo_CG.zip");
    await outputFile.writeAsBytes(zipFileBytes!);
    showToast("Archivo Zip de evidencia creado");
    return outputFile;
  }
}
