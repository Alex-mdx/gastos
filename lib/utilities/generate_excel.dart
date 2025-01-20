import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/models/categoria_model.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gastos/utilities/funcion_parser.dart' as parseo;
import '../models/periodo_model.dart';

class GenerateExcel {
  static Future<bool> backUp(GastoProvider provider) async {
    var excel = Excel.createExcel();
    Sheet sheet1 = excel['Gastos'];
    sheet1.appendRow(provider.listaGastos.first
        .toJson()
        .keys
        .map((e) => TextCellValue(e.toString()))
        .toList());
    for (var element in provider.listaGastos) {
      log("${element.toJson().values.map((e) => TextCellValue(e.toString())).toList()}");
      sheet1.appendRow(
          element.toJson().values.map((i) => TextCellValue("$i")).toList());
    }

    Sheet sheet2 = excel['Categorias'];
    sheet2.appendRow(provider.listaCategoria.first
        .toJson()
        .keys
        .map((e) => TextCellValue(e.toString()))
        .toList());
    for (var element in provider.listaCategoria) {
      sheet2.appendRow(element
          .toJson()
          .values
          .map((i) => TextCellValue(i.toString()))
          .toList());
    }

    final direccion = await getDownloadsDirectory();
    showToast("Dato generado");
    log("$direccion");
    String rutaArchivo = '${direccion?.path}/gasto.xlsx';

    File archivo = File(rutaArchivo);
    await archivo.writeAsBytes(excel.encode()!);
    final result = await Share.shareXFiles([XFile(rutaArchivo)]);
    if (result.status == ShareResultStatus.success) {
      showToast("Se compartio con exito el documento");
    } else {
      showToast("Hubo un problema al compartir");
    }
    return true;
  }

  static Future<bool> read(GastoProvider provider) async {
    FilePickerResult? pick = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        dialogTitle: "Ingrese los datos de sus gastos",
        allowedExtensions: ['xlsx']);
    if (pick != null) {
      var bytes = File(pick.files.first.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        switch (table) {
          case "Gastos":
            if (excel.tables[table]!.rows.length > 1) {
              await GastosController.deleteAll();

              for (var i = 0; i < excel.tables[table]!.rows.length; i++) {
                var row = excel.tables[table]!.rows[i];
                if (i != 0) {
                  GastoModelo gasto = GastoModelo(
                      id: int.tryParse(row[0]!.value.toString()),
                      categoriaId: int.tryParse(row[1]!.value.toString()),
                      metodoPagoId: int.tryParse(row[2]!.value.toString()),
                      monto: double.parse(row[3]!.value.toString()),
                      fecha: row[4]!.value.toString(),
                      dia: row[5]!.value.toString(),
                      mes: row[6]!.value.toString(),
                      peridico: int.tryParse(row[7]!.value.toString()),
                      ultimaFecha: row[8]!.value.toString() == "null"
                          ? null
                          : row[8]!.value.toString(),
                      periodo: PeriodoModelo.fromJson(
                          jsonDecode(row[9]!.value.toString())),
                      gasto: int.tryParse(row[10]!.value.toString()),
                      evidencia: row[11]!.value.toString() == "null"
                          ? []
                          : List<Uint8List>.from(
                              jsonDecode(row[11]!.value.toString()).map((x) =>
                                  parseo.Parser.toUint8List(x.toString()))),
                      nota: row[12]!.value.toString() == "null"
                          ? null
                          : row[12]!.value.toString());
                  log("${gasto.toJson()}");
                  await GastosController.insert(gasto);
                }
              }
            } else {
              showToast(
                  "Importacion cancelada, Tabla de $table vacia, respaldo corrupto");
            }

            break;
          case "Categorias":
            if (excel.tables[table]!.rows.length > 1) {
              await CategoriaController.deleteAll();
              for (var i = 0; i < excel.tables[table]!.rows.length; i++) {
                var row = excel.tables[table]!.rows[i];
                if (i != 0) {
                  CategoriaModel cateogoria = CategoriaModel(
                      id: int.tryParse(row[0]!.value.toString()),
                      nombre: row[1]!.value.toString(),
                      descripcion: row[2]!.value.toString());
                  log("${cateogoria.toJson()}");
                  await CategoriaController.insert(cateogoria);
                }
              }
            } else {
              showToast(
                  "Importacion cancelada, Tabla de $table vacia, respaldo corrupto");
            }
            break;
          default:
            showToast("hoja $table no permitida");
        }
      }
    } else {
      showToast("No se selecciono ningun archivo");
    }
    showToast("Importacion finalizada");
    return true;
  }
}
