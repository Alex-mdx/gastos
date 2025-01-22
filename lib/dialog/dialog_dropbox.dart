import 'dart:developer';

import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/material.dart';
import 'package:gastos/utilities/dropbox_gen.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';

class DialogDropbox extends StatefulWidget {
  const DialogDropbox({super.key});

  @override
  State<DialogDropbox> createState() => _DialogDropboxState();
}

class _DialogDropboxState extends State<DialogDropbox> {
  bool send = true;
  String proceso = "Sin proceso";
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text("Dropbox", style: TextStyle(fontSize: 16.sp)),
        Icon(LineIcons.dropbox, size: 24.sp),
      ]),
      Column(children: [
        if (Preferences.tokenDropbox == "")
          ElevatedButton.icon(
              icon:
                  Icon(Icons.login, size: 20.sp, color: LightThemeColors.green),
              onPressed: () async {
                var tipo = await DropboxGen.verificarLogeo();
                if (!tipo) {
                  await Dropbox.authorize();
                  await DropboxGen.verificarLogeo();
                }
                setState(() {});
              },
              label: Text("Iniciar sesion", style: TextStyle(fontSize: 15.sp))),
        if (Preferences.tokenDropbox != "")
          Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (send) {
                      setState(() {
                        send = false;
                        proceso = "En proceso";
                      });
                      final result = await Dropbox.getAccountName();
                      setState(() {
                        proceso = "Bienvenido a dropbox $result";
                      });
                      final url = await Dropbox.listFolder('');
                      setState(() {
                        proceso = "Se ingreso a su carpeta de respaldo $url";
                      });
                      final urls =
                          await Dropbox.getTemporaryLink('/gasto.xlsx');
                      print(urls);
                      setState(() {
                        proceso = "url: $urls";
                      });
                      if (urls!.contains("not_found")) {
                        showToast("No se encontro ningun archivo de respaldo");
                      } else {
                        showToast("viva la vida");
                      }
                      setState(() {
                        send = true;
                        proceso = "Sin proceso";
                      });
                    }
                  },
                  child: proceso == "Sin proceso"
                      ? Text("Sincronizar",
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: LightThemeColors.darkBlue,
                              fontWeight: FontWeight.bold))
                      : CircularProgressIndicator()),
              Text(proceso,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style:
                      TextStyle(fontSize: 14.sp, fontStyle: FontStyle.italic)),
              ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          send ? null : LightThemeColors.grey)),
                  onPressed: () async {
                    if (send) {
                      setState(() {
                        send = false;
                      });

                      await Dropbox.unlink();
                      var token = await Dropbox.getAccessToken();
                      log("token: $token");
                      if (token == null) {
                        print(token);
                        setState(() {
                          Preferences.tokenDropbox = "";
                        });
                        showToast("Se ha cerrado su sesion de dropbox");
                      }
                      setState(() {
                        send = true;
                      });
                    } else {
                      showToast("Proceso en curso");
                    }
                  },
                  label:
                      Text("Cerrar sesion", style: TextStyle(fontSize: 15.sp)),
                  icon: Icon(Icons.logout,
                      size: 20.sp, color: LightThemeColors.red)),
            ],
          )
      ])
    ]));
  }
}
