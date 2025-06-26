import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/utilities/detection_mime.dart';
import 'package:gastos/utilities/image_gen.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/zip_funcion.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/categoria_controller.dart';
import '../../controllers/gastos_controller.dart';
import '../../controllers/presupuesto_controller.dart';
import '../../utilities/auth.dart';
import '../../utilities/gasto_provider.dart';
import '../../utilities/generate_excel.dart';

class BackupManual extends StatelessWidget {
  const BackupManual({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return OverflowBar(
        overflowSpacing: .5.h,
        alignment: MainAxisAlignment.spaceAround,
        overflowAlignment: OverflowBarAlignment.center,
        children: [
          ElevatedButton.icon(
              onPressed: () => Dialogs.showMorph(
                  title: "Exportacion de datos",
                  description:
                      "Se generara un respaldo de sus gastos en formato ZIP\nNota1: Evite modificar dicho archivo desde programas externos para evitar futuros errores\nNota2: Se comprimiran sus evidencias fotograficas, el proceso podria tardar en funcion a la cantidad de evidencias",
                  loadingTitle: "Exportando",
                  onAcceptPressed: (context) async {
                    List<File> archivos = [];
                    var csv = await GenerateExcel.backUp();
                    if (csv != null) {
                      archivos.add(csv);
                    

                    var imagenes = await ImageGen.obtenerImagenesEvidencia();
                    archivos.addAll(imagenes);
                    var file = await ZipFuncion.toZip(archivos);
                    await GenerateExcel.compartidoGlobal(file!);
                    }
                  }),
              label: Text("Exportacion datos",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              icon: Icon(LineIcons.fileExport, size: 22.sp)),
          ElevatedButton.icon(
              onPressed: () {
                Dialogs.showMorph(
                    title: "Importacion de datos",
                    description:
                        "Ingrese un archivo de tipo ZIP para la importacion de sus datos\nNOTA: El archivo ZIP que seleccione debio ser generado desde la app de Control de Gastos, en caso de que haya sido manipulada y/o creado por programas externos podria corromper la importacion y por ende corromper sus datos",
                    loadingTitle: "Importando",
                    loadingDescription:
                        "Es proceso podria tardar unos minutos en funcion a la cantidad de datos almacenados",
                    onAcceptPressed: (context) async {
                      File? archivo = await GenerateExcel.importarGlobal();
                      if (archivo != null) {
                        await DetectionMime.operacion([archivo]);
                      } else {
                        showToast("No se pudo obtener el archivo");
                      }

                      provider.listaGastos =
                          await GastosController.getConfigurado();
                      provider.listaCategoria =
                          await CategoriaController.getItems();
                      provider.metodo = await MetodoGastoController.getItems();
                      log("${provider.metodo.map((e) => e.toJson()).toList()}");
                      provider.metodoSelect = provider.metodo
                          .firstWhereOrNull((element) => element.id == 1);
                    });
              },
              label: Text("Importar datos",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              icon: Icon(LineIcons.fileImport, size: 22.sp)),
              if(kDebugMode)
          ElevatedButton.icon(
              onPressed: () async {
                Dialogs.showMorph(
                    title: 'Eliminar datos',
                    description:
                        "¿Esta seguro de eliminar sus datos?\nSe pedira acceso a sus datos biometricos para asegurar su identidad",
                    loadingTitle: "Validando",
                    onAcceptPressed: (context) async {
                      final result = await Auth.obtener();
                      if (result) {
                        await ImageGen.limpiar();
                        await GastosController.deleteAll();
                        await CategoriaController.deleteAll();
                        await PresupuestoController.deleteAll();
                        await MetodoGastoController.deleteAll();
                        provider.listaGastos.clear();
                        provider.listaCategoria.clear();
                        provider.metodo.clear();
                        await MetodoGastoController.generarObtencion();
                        provider.metodo =
                            await MetodoGastoController.getItems();
                        provider.metodoSelect = provider.metodo
                            .firstWhereOrNull(
                                (element) => element.defecto == 1);
                        provider.presupuesto = null;
                      }
                    });
              },
              label: Text("Eliminar datos",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
              icon: Icon(LineIcons.trash, size: 18.sp))
        ]);
  }
}
