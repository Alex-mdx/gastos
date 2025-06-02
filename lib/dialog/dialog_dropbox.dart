import 'dart:developer';
import 'dart:io';

import 'package:dropbox_client/dropbox_client.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:gastos/models/dropbox_model.dart';
import 'package:gastos/utilities/image_gen.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

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

  DropboxModel? backOnline;
  @override
  void initState() {
    super.initState();
    token();
    file();
  }

  void token() async {
    if (mounted) {
      var token = (await Dropbox.getAccessToken()) ?? "";
      setState(() {
        Preferences.tokenDropbox = token;
      });
    }
  }

  Future<void> file() async {
    backOnline = await DropboxGen.infoFile(name: "respaldo_CG.zip");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: (send && descarga && carga),
        child: Dialog(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text("Dropbox", style: TextStyle(fontSize: 18.sp)),
            Icon(LineIcons.dropbox, size: 24.sp)
          ]),
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
                      ElevatedButton.icon(
                          icon: Icon(LineIcons.fileUpload,
                              size: 20.sp, color: ThemaMain.green),
                          onPressed: () async {
                            try {
                              List<File> archivos = [];
                              File? zip;
                              if (carga) {
                                setState(() {
                                  send = false;
                                  carga = false;
                                  proceso = "En proceso";
                                });
                                final result = await Dropbox.getAccountName();
                                setState(() {
                                  proceso = "Bienvenido a dropbox $result";
                                });

                                setState(() {
                                  proceso = "Generando respaldo";
                                });
                                var csv = await GenerateExcel.backUp();

                                if (csv != null) {
                                  archivos.add(csv);

                                  setState(() {
                                    proceso = "Optimizando evidencias";
                                  });
                                  var imagenes =
                                      await ImageGen.obtenerImagenesEvidencia();
                                  archivos.addAll(imagenes);
                                  setState(() {
                                    proceso = "Generando archivo comprimido";
                                  });
                                  zip = await ZipFuncion.toZip(archivos);
                                }
                                setState(() {
                                  proceso = "Enviando...";
                                });
                                if (zip != null) {
                                  await Dropbox.upload(
                                      zip.path,
                                      '/respaldo_CG.zip',
                                      (uploaded, total) => setState(() {
                                            proceso =
                                                "Progreso: ${filesize(uploaded)} / ${filesize(total)}";
                                          }));
                                  showToast("Subida de resplado con exito");
                                } else {
                                  showToast(
                                      "No se pudo generar el archivo compreso");
                                }

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
                          label: proceso == "Sin proceso"
                              ? Text("Guardar",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: ThemaMain.darkBlue,
                                      fontWeight: FontWeight.bold))
                              : CircularProgressIndicator()),
                      Column(
                        children: [
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
                                  final result = await Dropbox.getAccountName();
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
                                  final respaldo =
                                      await Dropbox.getTemporaryLink(
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
                                    final result = await Dropbox.download(
                                        "/respaldo_CG.zip",
                                        filepath,
                                        (downloaded, total) => setState(() {
                                              proceso =
                                                  "Descarga: ${filesize(downloaded)} / ${filesize(total)}";
                                            }));
                                    showToast("Descarga de resplado con exito");
                                    debugPrint("$result");
                                  }
                                  setState(() {
                                    descarga = true;
                                    send = true;
                                    proceso = "Sin proceso";
                                  });
                                } else {
                                  showToast("Descarga en proceso");
                                }
                              },
                              label: Text("Descargar",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: ThemaMain.darkBlue))),
                          Text("${backOnline?.serverModified}")
                        ],
                      )
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

                        var tipo = await DropboxGen.verificarLogeo();
                        log("$tipo");
                        if (!tipo) {
                          await Dropbox.authorize();
                        }

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
