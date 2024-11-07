import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'utilities/apis/rutas_app.dart';
import 'utilities/navegacion_provider.dart';
import 'utilities/preferences.dart';
import 'utilities/services/navigation_key.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Preferences.init();
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
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return OKToast(
          dismissOtherOnShow: true,
          position: ToastPosition.bottom,
          duration: const Duration(seconds: 4),
          textStyle: TextStyle(fontSize: 14.sp, color: Colors.white),
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
              theme: light,
              navigatorKey: NavigationKey.navigatorKey,
              initialRoute: AppRoutes.initialRoute,
              routes: AppRoutes.routes));
    });
  }
}
