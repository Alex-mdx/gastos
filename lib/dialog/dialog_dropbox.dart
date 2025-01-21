import 'dart:developer';

import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/material.dart';
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
                var token = await Dropbox.getAccessToken();
                if (token != null) {
                  print(token);
                  setState(() {
                    Preferences.tokenDropbox = token;
                  });
                  await Dropbox.authorizeWithAccessToken(
                      Preferences.tokenDropbox);
                  showToast("Acceso a dropbox correcto");
                } else {
                  Preferences.tokenDropbox = "";
                  await Dropbox.authorize();
                  showToast("No se pudo acceder a su cuenta de dropbox");
                }
              },
              label: Text("Iniciar sesion", style: TextStyle(fontSize: 15.sp))),
        if (Preferences.tokenDropbox != "")
          Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final result =
                        await Dropbox.getAccountName(); // list root folder
                    print("resultado: $result");

                    final url = await Dropbox.listFolder('');
                    print("url : $url");
                  },
                  child: Text("Sincronizar",
                      style: TextStyle(
                          fontSize: 15.sp,
                          color: LightThemeColors.darkBlue,
                          fontWeight: FontWeight.bold))),
              Text("Proceso:"),
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
