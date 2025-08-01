import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/bidones_controller.dart';
import 'package:gastos/controllers/categoria_controller.dart';
import 'package:gastos/controllers/gastos_controller.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/controllers/presupuesto_controller.dart';
import 'package:gastos/models/bidones_model.dart';
import 'package:gastos/models/categoria_model.dart';
import 'package:gastos/models/gasto_model.dart';
import 'package:gastos/models/metodo_pago_model.dart';
import 'package:gastos/models/presupuesto_model.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/periodo_model.dart';

class GenerateExcel {
  static Future<File?> backUp() async {
    try {
      showToast("Generando csv de gastos");
      var excel = Excel.createExcel();
      Sheet sheet1 = excel['Gastos'];

      var gastos = await GastosController.getAll();
      if (gastos.isNotEmpty) {
        sheet1.appendRow(gastos.first
            .toJson()
            .keys
            .map((e) => TextCellValue(e.toString()))
            .toList());
        for (var element in gastos) {
          log("${element.toJson().values.map((e) => TextCellValue(e.toString())).toList()}");
          sheet1.appendRow(
              element.toJson().values.map((i) => TextCellValue("$i")).toList());
        }
      }

      Sheet sheet2 = excel['Categorias'];
      var categorias = await CategoriaController.getItems();
      if (categorias.isNotEmpty) {
        sheet2.appendRow(categorias.first
            .toJson()
            .keys
            .map((e) => TextCellValue(e.toString()))
            .toList());
        for (var element in categorias) {
          sheet2.appendRow(element
              .toJson()
              .values
              .map((i) => TextCellValue(i.toString()))
              .toList());
        }
      }

      Sheet sheet3 = excel['MetodoPago'];
      var metodoPago = await MetodoGastoController.getItems();
      if (metodoPago.isNotEmpty) {
        sheet3.appendRow(metodoPago.first
            .toJson()
            .keys
            .map((e) => TextCellValue(e.toString()))
            .toList());
        for (var element in metodoPago) {
          sheet3.appendRow(element
              .toJson()
              .values
              .map((i) => TextCellValue(i.toString()))
              .toList());
        }
      }

      var presupuesto = await PresupuestoController.getItem();
      if (presupuesto != null) {
        Sheet sheet4 = excel['Presupuesto'];
        sheet4.appendRow(presupuesto
            .toJson()
            .keys
            .map((e) => TextCellValue(e.toString()))
            .toList());

        sheet4.appendRow(presupuesto
            .toJson()
            .values
            .map((i) => TextCellValue(i.toString()))
            .toList());
      }

      Sheet sheet5 = excel['BidonesPresupuesto'];
      var bidones = await BidonesController.getItems();
      if (bidones.isNotEmpty) {
        sheet5.appendRow(bidones.first
            .toJson()
            .keys
            .map((e) => TextCellValue(e.toString()))
            .toList());
        for (var element in bidones) {
          sheet5.appendRow(element
              .toJson()
              .values
              .map((i) => TextCellValue(i.toString()))
              .toList());
        }
      }

      final direccion = await getDownloadsDirectory();
      showToast("Guardando respaldo generado");
      log("$direccion");
      String rutaArchivo = '${direccion?.path}/gasto.xlsx';
      File archivo = File(rutaArchivo);
      await archivo.writeAsBytes(excel.encode()!);
      return archivo;
    } catch (e) {
      debugPrint("$e");
      showToast("Error al generar resplado de datos csv\n$e");
      return null;
    }
  }

  static Future<bool> compartidoGlobal(File file) async {
    final params = ShareParams(text: 'Evidencia', files: [XFile(file.path)]);

    final result = await SharePlus.instance.share(params);
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
        allowedExtensions: ['xlsx', 'zip', 'rar']);
    if (pick != null) {
      var file = File(pick.files.first.path!);
      return file;
    } else {
      showToast("No se optuvo ningun dato");
      return null;
    }
  }

  static Future<bool> read(File? csv) async {
    //try {
    if (csv != null) {
      showToast("Leyendo datos");
      var bytes = csv.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      log("${excel.tables.keys}");
      for (var table in excel.tables.keys) {
        List<Data?> row = [];
        var maximo = 0;
        switch (table) {
          case "Gastos":
            if (excel.tables[table]!.rows.length > 1) {
              showToast("Leyendo Gastos");
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
                              : List<String>.from(
                                  jsonDecode(row[10]!.value.toString())
                                      .map((x) => x.toString()))
                          : [],
                      nota: 11 < maximo
                          ? row[11]!.value.toString() == "null"
                              ? null
                              : row[11]!.value.toString()
                          : null,
                      metodoPagoId: 12 < maximo
                          ? int.tryParse(row[12]!.value.toString())
                          : null);
                  await GastosController.insert(gasto);
                }
                showToast("Guardado de gastos");
              }
            } else {
              showToast(
                  "Importacion cancelada, Tabla de $table vacia, respaldo corrupto");
            }

            break;
          case "Categorias":
            if (excel.tables[table]!.rows.length > 1) {
              showToast("Leyendo Categorias");
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
                  await CategoriaController.insert(cateogoria);
                }
              }
              showToast("Guardado de Categorias");
            } else {
              showToast(
                  "Importacion cancelada, Tabla de $table vacia, respaldo corrupto");
            }
            break;

          case "MetodoPago":
            if (excel.tables[table]!.rows.length > 1) {
              showToast("Leyendo Metodos de Pago");
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
                          : ThemaMain.primary);
                  await MetodoGastoController.insert(metodoGasto);
                }
              }
              showToast("Guardado de Metodo de Pago");
            } else {
              showToast(
                  "Importacion cancelada, Tabla de $table vacia, respaldo corrupto");
            }
            break;
          case "Presupuesto":
            if (excel.tables[table]!.rows.length > 1) {
              showToast("Leyendo Presupuesto");
              await PresupuestoController.deleteAll();
              for (var i = 0; i < excel.tables[table]!.rows.length; i++) {
                row = excel.tables[table]!.rows[i];
                maximo = row.length;
                if (i != 0) {
                  ///ni me acuerdo para que servia el periodo
                  PresupuestoModel presupuesto = PresupuestoModel(
                      activo: 0 < maximo
                          ? int.tryParse(row[0]!.value.toString())!
                          : 0,
                      presupuesto: 1 < maximo
                          ? double.parse(row[1]!.value.toString())
                          : null,
                      lunes: 2 < maximo
                          ? double.parse(row[2]!.value.toString())
                          : null,
                      martes: 3 < maximo
                          ? double.parse(row[3]!.value.toString())
                          : null,
                      miercoles: 4 < maximo
                          ? double.parse(row[4]!.value.toString())
                          : null,
                      jueves: 5 < maximo
                          ? double.parse(row[5]!.value.toString())
                          : null,
                      viernes: 6 < maximo
                          ? double.parse(row[6]!.value.toString())
                          : null,
                      sabado: 7 < maximo
                          ? double.parse(row[7]!.value.toString())
                          : null,
                      domingo: 8 < maximo
                          ? double.parse(row[8]!.value.toString())
                          : null,
                      periodo: 9 < maximo
                          ? int.tryParse(row[9]!.value.toString())
                          : null);
                  await PresupuestoController.insert(presupuesto);
                }
              }
              showToast("Guardo Presupuesto");
            } else {
              showToast(
                  "Importacion cancelada, Tabla de $table vacia, respaldo corrupto");
            }
            break;
          case "BidonesPresupuesto":
            if (excel.tables[table]!.rows.length > 1) {
              debugPrint("leyendo");
              await BidonesController.deleteAll();
              showToast("Guardo Bidones de Presupuesto");
              for (var i = 0; i < excel.tables[table]!.rows.length; i++) {
                row = excel.tables[table]!.rows[i];
                maximo = row.length;
                log("bPre: ${row.map((e) => e!.value.toString())} ${i != 0}");
                if (i != 0) {
                  BidonesModel bidon = BidonesModel(
                      id: 0 < maximo
                          ? int.tryParse(row[0]!.value.toString())!
                          : 1,
                      identificador: row[1]!.value.toString(),
                      nombre: row[2]!.value.toString(),
                      montoInicial: 3 < maximo
                          ? double.parse(row[3]!.value.toString())
                          : 0,
                      montoFinal: 4 < maximo
                          ? double.parse(row[4]!.value.toString())
                          : 0,
                      metodoPago: 5 < maximo
                          ? row[5]!.value.toString() == "null"
                              ? []
                              : List<int>.from(
                                  jsonDecode(row[5]?.value.toString() ?? "[]")
                                      .map((x) => int.parse(x.toString())))
                          : [],
                      categoria: 6 < maximo
                          ? row[6]!.value.toString() == "null"
                              ? []
                              : List<int>.from(
                                  jsonDecode(row[6]?.value.toString() ?? "[]")
                                      .map((x) => int.parse(x.toString())))
                          : [],
                      diasEfecto: 7 < maximo
                          ? row[7]!.value.toString() == "null"
                              ? []
                              : List<int>.from(
                                  jsonDecode(row[7]?.value.toString() ?? "[]")
                                      .map((x) => int.parse(x.toString())))
                          : [],
                      fechaInicio: DateTime.parse(row[8]!.value.toString()),
                      fechaFinal: DateTime.parse(row[9]!.value.toString()),
                      cerrado: 10 < maximo
                          ? int.parse(row[10]!.value.toString())
                          : 0,
                      inhabilitado: 11 < maximo
                          ? int.parse(row[11]!.value.toString())
                          : 0,
                      gastos: 12 < maximo
                          ? row[12]!.value.toString() == "null"
                              ? []
                              : List<int>.from(jsonDecode(row[12]?.value.toString() ?? "[]").map((x) => int.parse(x.toString())))
                          : []);
                  log("${bidon.toJson()}");
                  await BidonesController.insert(bidon);
                }
                showToast("Guardo Bidones de Presupuesto");
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
    /* } catch (e) {
      showToast("Error al leer datos\n$e");
      return false;
    } */

    return true;
  }
}
