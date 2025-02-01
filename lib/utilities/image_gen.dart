import 'dart:io';
import 'dart:typed_data';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';

class ImageGen {
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

  static Future<void> limpiar() async {
    // Obtener la carpeta de descargas
    showToast("eliminando evidencias");
    final direccion = await getDownloadsDirectory();
    if (direccion != null && await direccion.exists()) {
      // Listar todos los archivos en la carpeta
      final archivos = direccion.listSync();
      for (var archivo in archivos) {
        // Verificar si es un archivo y no una carpeta
        if (archivo is File) {
          try {
            // Eliminar el archivo
            await archivo.delete();
            print('Archivo eliminado: ${archivo.path}');
          } catch (e) {
            print('Error al eliminar el archivo: ${archivo.path}, error: $e');
          }
        }
      }
    } else {
      print('No se pudo encontrar la carpeta de descargas.');
    }
  }

  static Future<File?> find(String nombre) async {
    // Obtener el directorio de descargas
    final directory = await getDownloadsDirectory();
    // Listar todos los elementos dentro del directorio
    final elementos = directory!.listSync();
    // Buscar el archivo por nombre
    for (var elemento in elementos) {
      if (elemento is File && elemento.path.endsWith(nombre)) {
        print('Archivo encontrado: ${elemento.path}');
        return elemento; // Retornar el archivo encontrado
      }
    }
    print('Archivo no encontrado.');
    return null; // Retornar null si no se encuentra el archivo
  }

  static Future<File?> generar(
      {required Uint8List archivo, required String name}) async {
    final directory = await getDownloadsDirectory();
    // Crea un archivo en la ruta especificada
    final file = File("${directory!.path}/$name.jpeg");
    // Escribe los datos del Uint8List en el archivo
    await file.writeAsBytes(archivo);
    print("archivo generado ${file.path}");
    return file;
  }
}
