import 'dart:io';
import 'package:excel/excel.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';

class GenerateExcel {
  static backUp(GastoProvider provider) async {
    var excel = Excel.createExcel();
    Sheet sheet1 = excel['Gastos'];
    sheet1.appendRow(provider.listaGastos.first
        .toJson()
        .keys
        .map((e) => TextCellValue(e.toString()))
        .toList());
    for (var element in provider.listaGastos) {
      sheet1.appendRow(element
          .toJson()
          .values
          .map((i) => TextCellValue(i.toString()))
          .toList());
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
    print(direccion);
    String rutaArchivo =
        '${direccion?.path}/gasto.xlsx';
    File archivo = File(rutaArchivo);
    await archivo.writeAsBytes(excel.encode()!);
    showToast("Se ha guardado sus datos");
  }
}
