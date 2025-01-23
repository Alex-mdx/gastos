import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/models/categoria_model.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:gastos/models/metodo_pago_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/periodo_model.dart';

class GenerateExcel {
  static Future<File?> backUp(GastoProvider provider) async {
    try {
      showToast("Generando csv de gastos");
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

      Sheet sheet3 = excel['MetodoPago'];
      sheet3.appendRow(provider.metodo.first
          .toJson()
          .keys
          .map((e) => TextCellValue(e.toString()))
          .toList());
      for (var element in provider.metodo) {
        sheet3.appendRow(element
            .toJson()
            .values
            .map((i) => TextCellValue(i.toString()))
            .toList());
      }
      final direccion = await getDownloadsDirectory();
      showToast("Guardando respaldo generado");
      log("$direccion");
      String rutaArchivo = '${direccion?.path}/gasto.xlsx';
      File archivo = File(rutaArchivo);
      await archivo.writeAsBytes(excel.encode()!);
      return archivo;
    } catch (e) {
      print(e);
      showToast("Error al generar resplado de datos csv\n$e");
      return null;
    }
  }

  static Future<bool> compartidoGlobal(File file) async {
    String rutaArchivo = file.path;
    final result = await Share.shareXFiles([XFile(rutaArchivo)]);
    if (result.status == ShareResultStatus.success) {
      showToast("Se compartio con exito el documento");
    } else {
      showToast("Hubo un problema al compartir");
    }
    return true;
  }

  static Future<File?> importarGlobal() async {
    FilePickerResult? pick = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        dialogTitle: "Ingrese los datos de sus gastos",
        allowedExtensions: ['xlsx', 'zip']);
    if (pick != null) {
      var file = File(pick.files.first.path!);
      return file;
    } else {
      showToast("No se optuvo ningun dato");
      return null;
    }
  }

  static Future<bool> read(File? csv) async {
    if (csv != null) {
      var bytes = csv.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        List<Data?> row = [];
        var maximo = 0;
        switch (table) {
          case "Gastos":
            if (excel.tables[table]!.rows.length > 1) {
              await GastosController.deleteAll();
              for (var i = 0; i < excel.tables[table]!.rows.length; i++) {
                row = excel.tables[table]!.rows[i];
                maximo = row.length;
                //! 12 = ?
                if (i != 0) {
                  GastoModelo gasto = GastoModelo(
                      id: 0 < maximo
                          ? int.tryParse(row[0]!.value.toString())
                          : null,
                      categoriaId: 1 < maximo
                          ? int.tryParse(row[1]!.value.toString())
                          : null,
                      monto: 2 < maximo
                          ? double.parse(row[2]!.value.toString())
                          : null,
                      fecha: 3 < maximo ? row[3]!.value.toString() : null,
                      dia: 4 < maximo ? row[4]!.value.toString() : null,
                      mes: 5 < maximo ? row[5]!.value.toString() : null,
                      peridico: 6 < maximo
                          ? int.tryParse(row[6]!.value.toString())
                          : null,
                      ultimaFecha: 7 < maximo
                          ? row[7]!.value.toString() == "null"
                              ? null
                              : row[7]!.value.toString()
                          : null,
                      periodo: 8 < maximo
                          ? PeriodoModelo.fromJson(
                              jsonDecode(row[8]!.value.toString()))
                          : PeriodoModelo(
                              year: null,
                              mes: null,
                              dia: null,
                              modificable: null),
                      gasto: 9 < maximo
                          ? int.tryParse(row[9]!.value.toString())
                          : null,
                      evidencia: 10 < maximo
                          ? row[10]!.value.toString() == "null"
                              ? []
                              : List<String>.from(jsonDecode(
                                      row[10]!.value.toString())
                                  .map((x) =>
                                      x.toString()))
                          : [],
                      nota: 11 < maximo
                          ? row[11]!.value.toString() == "null"
                              ? null
                              : row[11]!.value.toString()
                          : null,
                      metodoPagoId: 12 < maximo
                          ? int.tryParse(row[12]!.value.toString())
                          : null);
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
                row = excel.tables[table]!.rows[i];
                maximo = row.length;
                if (i != 0) {
                  CategoriaModel cateogoria = CategoriaModel(
                      id: 0 < maximo
                          ? int.tryParse(row[0]!.value.toString())
                          : null,
                      nombre: 0 < maximo ? row[1]!.value.toString() : "",
                      descripcion: 0 < maximo ? row[2]!.value.toString() : "");
                  log("${cateogoria.toJson()}");
                  await CategoriaController.insert(cateogoria);
                }
              }
            } else {
              showToast(
                  "Importacion cancelada, Tabla de $table vacia, respaldo corrupto");
            }
            break;

          case "MetodoPago":
            if (excel.tables[table]!.rows.length > 1) {
              await MetodoGastoController.deleteAll();
              for (var i = 0; i < excel.tables[table]!.rows.length; i++) {
                row = excel.tables[table]!.rows[i];
                maximo = row.length;
                if (i != 0) {
                  MetodoPagoModel metodoGasto = MetodoPagoModel(
                      id: 0 < maximo
                          ? int.tryParse(row[0]!.value.toString())!
                          : 1,
                      nombre: 1 < maximo ? row[1]!.value.toString() : "",
                      cambio: 2 < maximo
                          ? double.parse(row[2]!.value.toString())
                          : 1,
                      denominacion:
                          3 < maximo ? row[3]!.value.toString() : "MXN",
                      status:
                          4 < maximo ? int.parse(row[4]!.value.toString()) : 0,
                      defecto:
                          5 < maximo ? int.parse(row[5]!.value.toString()) : 1,
                      color: 6 < maximo
                          ? Color(int.parse(row[6]!.value.toString()))
                          : LightThemeColors.primary);
                  log("${metodoGasto.toJson()}");
                  await MetodoGastoController.insert(metodoGasto);
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
      showToast("Importacion finalizada");
    } else {
      showToast("No se encontro ningun archivo");
    }

    return true;
  }
}
