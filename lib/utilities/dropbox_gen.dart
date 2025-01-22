import 'package:dropbox_client/dropbox_client.dart';
import 'package:gastos/utilities/preferences.dart';

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
}
