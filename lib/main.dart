import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'utilities/apis/rutas_app.dart';
import 'utilities/navegacion_provider.dart';
import 'utilities/notificaciones_fun.dart';
import 'utilities/preferences.dart';
import 'utilities/services/navigation_key.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    if (kDebugMode) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    }
    return client;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  HttpOverrides.global = MyHttpOverrides();
  await Preferences.init();
  await dotenv.load(fileName: ".env");
  await Dropbox.init(dotenv.env['DROPBOX_KEY'] ?? "",
      dotenv.env['DROPBOX_SECRET'] ?? "", dotenv.env['DROPBOX_TOKEN'] ?? "");
  await NotificacionesFun.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => GastoProvider()),
      ChangeNotifierProvider(create: (_) => NavigationProvider())
    ], child: const Main()));
  });
}

class Main extends StatelessWidget {
  const Main({super.key});
  @override
  Widget build(BuildContext context) => Sizer(
      builder: (context, orientation, deviceType) => OKToast(
          dismissOtherOnShow: true,
          position: ToastPosition.bottom,
          duration: const Duration(seconds: 4),
          backgroundColor:
              Preferences.isLightTheme ? Colors.white : Colors.black,
          textStyle: TextStyle(
              fontSize: 15.sp,
              color: Preferences.isLightTheme ? Colors.black : Colors.white),
          child: MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: const [
                Locale('es')
              ],
              debugShowCheckedModeBanner: false,
              title: 'Gastos',
              themeMode:
                  Preferences.isLightTheme ? ThemeMode.light : ThemeMode.dark,
              theme: Preferences.isLightTheme ? light : dark,
              navigatorKey: NavigationKey.navigatorKey,
              initialRoute: AppRoutes.initialRoute,
              routes: AppRoutes.routes)));
}
