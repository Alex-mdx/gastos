import 'dart:convert';

import 'package:dropbox_client/dropbox_client.dart';
import 'package:gastos/models/dropbox_model.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:get/utils.dart';
import 'package:oktoast/oktoast.dart';

class DropboxGen {
  static Future<bool> verificarLogeo() async {
    var result = await Dropbox.getAccessToken();
    if (result != null) {
      Preferences.tokenDropbox = result;
      await Dropbox.authorizeWithAccessToken(result);
      return true;
    } else {
      Preferences.tokenDropbox = "";
      return false;
    }
  }


  static Future<DropboxModel?> infoFile({required String name}) async {
    try {
    var result = await Dropbox.listFolder("");
    List<DropboxModel> drop = [];
    for (var element in result) {
      drop.add(DropboxModel.fromJson(jsonDecode(jsonEncode(element))));
    }
    var coincidencia = drop
        .firstWhereOrNull((element) => element.name?.contains(name) ?? false);
    return coincidencia;
} catch (e) {
      showToast("error $e");
      return null;
    } 
  }
}
