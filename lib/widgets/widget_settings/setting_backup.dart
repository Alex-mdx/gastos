import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gastos/controllers/metodo_gasto_controller.dart';
import 'package:gastos/utilities/image_gen.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
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
                    /* await GenerateExcel.backUp(provider);
                    await GenerateExcel.compartir(); */
                    await ImageGen.generarImagen();

                    var imagenes = await ImageGen.obtenerImagenesEvidencia();
                    var file = await GenerateExcel.toZip(imagenes);
                    await GenerateExcel.compartidoGlobal(file!);
                  }),
              label: Text("Exportacion datos",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              icon: Icon(LineIcons.fileUpload, size: 20.sp)),
          ElevatedButton.icon(
              onPressed: () {
                Dialogs.showMorph(
                    title: "Importacion de datos",
                    description:
                        "Ingrese un archivo de tipo XLSX para la importacion de sus datos\nNOTA: El archivo XSLX que seleccione debio ser generado desde la app de Control de Gastos, en caso de que haya sido manipulada y/o creado por programas externos podria corromper la importacion",
                    loadingTitle: "Importando",
                    loadingDescription:
                        "Es proceso podria tardar unos minutos en funcion a la cantidad de datos almacenados",
                    onAcceptPressed: (context) async {
                      await GenerateExcel.read(provider);
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
              icon: Icon(LineIcons.fileImport, size: 20.sp)),
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
