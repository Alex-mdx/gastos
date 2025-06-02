import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dropbox_client/dropbox_client.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:gastos/models/dropbox_model.dart';
import 'package:gastos/models/user_dropbox_model.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/image_gen.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/textos.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:get/utils.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../controllers/categoria_controller.dart';
import '../controllers/gastos_controller.dart';
import '../controllers/metodo_gasto_controller.dart';
import '../utilities/detection_mime.dart';
import '../utilities/dropbox_gen.dart';
import '../utilities/generate_excel.dart';
import '../utilities/zip_funcion.dart';

class DialogDropbox extends StatefulWidget {
  const DialogDropbox({super.key});

  @override
  State<DialogDropbox> createState() => _DialogDropboxState();
}

class _DialogDropboxState extends State<DialogDropbox> {
  bool send = true;
  bool descarga = true;
  bool carga = true;
  String proceso = "Sin proceso";
  UserDropboxModel? data;

  DropboxModel? backOnline;
  File? backData;
  @override
  void initState() {
    super.initState();
    token();
    fileData();
  }

  void token() async {
    if (mounted) {
      var token = (await Dropbox.getAccessToken()) ?? "";
      log("log: $token");

      setState(() {
        Preferences.tokenDropbox = token;
      });
      if (token != "") {
        data = UserDropboxModel.fromJson(jsonDecode(
            jsonEncode((await Dropbox.getCurrentAccount())?.toMap())));
        await file();
      }
    }
  }

  Future<void> file() async {
    var data = await DropboxGen.infoFile(name: "respaldo_CG.zip");
    print("${data?.toJson()}");
    if (mounted) {
      setState(() {
        backOnline = data;
      });
    }
  }

  Future<void> fileData() async {
    var data = await ImageGen.find("respaldo_CG.zip");
    print("$data");
    if (mounted) {
      setState(() {
        backData = data;
      });
    }
  }

  Future<void> cargaData(
      GastoProvider provider, Function(String) procesar) async {
    List<File> archivos = [];
    File? zip;

    procesar("Generando respaldo");
    var csv = await GenerateExcel.backUp();

    if (csv != null) {
      archivos.add(csv);
      procesar("Optimizando evidencias");
      var imagenes = await ImageGen.obtenerImagenesEvidencia();
      archivos.addAll(imagenes);
      procesar("Generando archivo comprimido");
      zip = await ZipFuncion.toZip(archivos);
      await fileData();
    }
    procesar("Enviando...");
    if (zip != null) {
      var cargado = 0;
      var totalizado = 0;
      await Dropbox.upload(
          zip.path,
          '/respaldo_CG.zip',
          (uploaded, total) => setState(() {
                cargado = uploaded;
                totalizado = total;
                procesar(
                    "Progreso: ${filesize(uploaded)} / ${filesize(total)}");
              }));
      if ((cargado != 0 && totalizado != 0) && (cargado == totalizado)) {
        showToast("Subida de datos finalizada con exito");
        await file();
      } else {
        showToast("No se pudo enviar los datos");
      }
    } else {
      showToast("No se pudo generar el archivo compreso");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return PopScope(
        canPop: (send && descarga && carga),
        child: Dialog(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text("Dropbox", style: TextStyle(fontSize: 18.sp)),
            Icon(LineIcons.dropbox, size: 24.sp),
          ]),
          if (data != null)
            Row(
              children: [
                SizedBox(
                    height: 22.sp,
                    width: 22.sp,
                    child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(60),
                        child: Image.network(data!.profilePhotoUrl,
                            filterQuality: FilterQuality.low))),
                TextButton.icon(
                    icon: Icon(Icons.open_in_new, size: 22.sp),
                    onPressed: () {},
                    label: Text("Ir", style: TextStyle(fontSize: 16.sp)))
              ],
            ),
          Divider(),
          Column(children: [
            if (Preferences.tokenDropbox == "")
              ElevatedButton.icon(
                  icon: Icon(Icons.login, size: 20.sp, color: ThemaMain.green),
                  onPressed: () async {
                    Dialogs.showMorph(
                        title: "Iniciar cuenta de DropBox",
                        description:
                            "La aplicacion va a requierir enlazarse con dropbox",
                        loadingTitle: "Iniciando",
                        onAcceptPressed: (context) async {
                          var tipo = await DropboxGen.verificarLogeo();
                          if (!tipo) {
                            await Dropbox.authorize();
                            var result = await DropboxGen.verificarLogeo();
                            if (result) {
                              showToast(
                                  "Se enlazo su app con su cuenta de Dropbox");
                            } else {
                              showToast("No se pudo enlazar");
                            }
                          }
                        });
                  },
                  label: Text("Iniciar sesion",
                      style: TextStyle(fontSize: 15.sp))),
            if (Preferences.tokenDropbox != "")
              Column(children: [
                OverflowBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    send ? null : ThemaMain.grey)),
                            icon: Icon(LineIcons.fileUpload,
                                size: 20.sp, color: ThemaMain.green),
                            onPressed: () async {
                              try {
                                if (carga) {
                                  setState(() {
                                    send = false;
                                    carga = false;
                                    proceso = "En proceso";
                                  });
                                  await cargaData(
                                      provider,
                                      (p0) => setState(() {
                                            proceso = p0;
                                          }));
                                  setState(() {
                                    send = true;
                                    carga = true;
                                    proceso = "Sin proceso";
                                  });
                                }
                              } catch (e) {
                                Preferences.tokenDropbox = "";
                                setState(() {
                                  send = false;
                                });
                                debugPrint("$e");
                              }
                            },
                            label: carga == true
                                ? Text("Guardar",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: ThemaMain.darkBlue,
                                        fontWeight: FontWeight.bold))
                                : CircularProgressIndicator()),
                        Text(
                            backData == null
                                ? "Sin respaldo local"
                                : "Ultimo Respaldo\n${Textos.fechaYMDHMS(fecha: backData!.lastModifiedSync())}\n${filesize(backData!.lengthSync())}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold))
                      ]),
                      Column(children: [
                        ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    send ? null : ThemaMain.grey)),
                            icon: Icon(LineIcons.fileDownload, size: 20.sp),
                            onPressed: () async {
                              if (send) {
                                setState(() {
                                  descarga = false;
                                  send = false;
                                  proceso = "En proceso";
                                });
                                /* final result = await Dropbox.getAccountName();
                                setState(() {
                                  proceso = "Bienvenido a dropbox $result";
                                });
                                final url = await Dropbox.listFolder('');
                                setState(() {
                                  proceso =
                                      "Se ingreso a su carpeta de respaldo $url";
                                });
                                setState(() {
                                  proceso = "Buscando archivo de respaldo";
                                });
                                final respaldo = await Dropbox.getTemporaryLink(
                                    '/respaldo_CG.zip');
                                log("resplado $respaldo");
                                if (respaldo!
                                    .toString()
                                    .contains("not_found")) {
                                  showToast(
                                      "No se encontro archivo de respaldo");
                                } else {
                                  final direccion =
                                      await getDownloadsDirectory();
                                  final filepath =
                                      '${direccion?.path}/respaldo_CG.zip';
                                  var descargado = 0;
                                  var totalizado = 0;

                                  final result = await Dropbox.download(
                                      "/respaldo_CG.zip",
                                      filepath,
                                      (downloaded, total) => setState(() {
                                            descargado = downloaded;
                                            totalizado = total;
                                            proceso =
                                                "Descarga: ${filesize(downloaded)} / ${filesize(total)}";
                                          }));
                                  print(
                                      "${(descargado != 0 && totalizado != 0)} ${(descargado == totalizado)}");
                                  if ((descargado != 0 && totalizado != 0) &&
                                      (descargado == totalizado)) {
                                    showToast("Archivo descargado");
                                    setState(() {
                                      proceso =
                                          "Descomprimiendo archivo zip...";
                                    });
                                    var files =
                                        await ZipFuncion.unZip(File(filepath));
                                    setState(() {
                                      proceso =
                                          "Guardando datos en la memoria interna";
                                    });
                                    await DetectionMime.operacion(files);
                                    setState(() {
                                      proceso = "Guardando gastos";
                                    });
                                    provider.listaGastos =
                                        await GastosController.getConfigurado();
                                    setState(() {
                                      proceso = "Guardando categorias";
                                    });
                                    provider.listaCategoria =
                                        await CategoriaController.getItems();
                                    setState(() {
                                      proceso = "Guardando metodo de gasto";
                                    });
                                    provider.metodo =
                                        await MetodoGastoController.getItems();
                                    log("${provider.metodo.map((e) => e.toJson()).toList()}");
                                    provider.metodoSelect = provider.metodo
                                        .firstWhereOrNull(
                                            (element) => element.id == 1);
                                  } else {
                                    showToast(
                                        "Error en la descarga de archivo");
                                  }

                                  debugPrint("descarga: $result");
                                } */

                                setState(() {
                                  descarga = true;
                                  send = true;
                                  proceso = "Sin proceso";
                                });
                              } else {
                                showToast("Descarga en proceso");
                              }
                            },
                            label: descarga == true
                                ? Text("Descargar",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: ThemaMain.darkBlue))
                                : CircularProgressIndicator()),
                        Text(
                            backOnline?.serverModified == null
                                ? "Sin datos de respaldo"
                                : "Ultimo Respaldo\n${backOnline!.serverModified!}\n${filesize(backOnline?.filesize ?? 0)}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold))
                      ])
                    ]),
                Text(proceso,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style: TextStyle(
                        fontSize: 14.sp, fontStyle: FontStyle.italic)),
                ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            send ? null : ThemaMain.grey)),
                    onPressed: () async {
                      if (send) {
                        setState(() {
                          send = false;
                        });

                        await Dropbox.authorize();
                        setState(() {
                          send = true;
                        });
                      } else {
                        showToast("Proceso en curso");
                      }
                    },
                    label: Text("Refrescar sesion",
                        style: TextStyle(fontSize: 15.sp)),
                    icon:
                        Icon(Icons.sync, size: 20.sp, color: ThemaMain.primary))
              ])
          ])
        ])));
  }
}
