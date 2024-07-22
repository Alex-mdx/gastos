import 'package:flutter/material.dart';
import 'package:gastos/utilities/preferences.dart';
import 'theme_color.dart';

const double borderRadius = 10.0;
ThemeData light = ThemeData(
    primaryColor: LightThemeColors.primary,
    colorScheme: ColorScheme.fromSeed(seedColor: LightThemeColors.primary),
    dividerColor: LightThemeColors.grey,
    textTheme: const TextTheme(
        bodyLarge: TextStyle(color: LightThemeColors.darkBlue),
        bodyMedium: TextStyle(color: LightThemeColors.darkBlue),
        bodySmall: TextStyle(color: LightThemeColors.darkBlue),
        displaySmall: TextStyle(color: LightThemeColors.darkBlue),
        displayMedium: TextStyle(color: LightThemeColors.darkBlue),
        displayLarge: TextStyle(color: LightThemeColors.darkBlue),
        headlineLarge: TextStyle(color: LightThemeColors.darkBlue),
        headlineMedium: TextStyle(color: LightThemeColors.darkBlue),
        headlineSmall: TextStyle(color: LightThemeColors.darkBlue),
        titleMedium: TextStyle(color: LightThemeColors.darkBlue),
        titleLarge: TextStyle(
            color: LightThemeColors.darkBlue,
            fontSize: 36,
            fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: LightThemeColors.darkBlue)),
    scaffoldBackgroundColor: LightThemeColors.background,
    dialogBackgroundColor: LightThemeColors.dialogbackground,
    cardTheme: const CardTheme(elevation: 2, color: LightThemeColors.second),
    iconTheme: const IconThemeData(color: LightThemeColors.primary),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            iconColor: WidgetStateProperty.all<Color>(LightThemeColors.primary),
            iconSize: WidgetStateProperty.all<double>(30),
            splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory)),
    switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all<Color>(LightThemeColors.primary),
        trackColor: WidgetStateProperty.all<Color>(
            LightThemeColors.primary.withAlpha(50))),
    radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all<Color>(LightThemeColors.primary)),
    primaryIconTheme: const IconThemeData(color: LightThemeColors.primary),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: LightThemeColors.primary,
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
    scrollbarTheme: const ScrollbarThemeData(
        radius: Radius.circular(24),
        thumbColor: WidgetStatePropertyAll(Colors.grey)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.white),
            elevation: WidgetStateProperty.all<double>(0),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))))),
    inputDecorationTheme: InputDecorationTheme(prefixIconColor: LightThemeColors.darkGrey, suffixIconColor: LightThemeColors.primary, fillColor: Colors.white, filled: true, iconColor: LightThemeColors.primary, contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20), floatingLabelStyle: const TextStyle(color: LightThemeColors.primary), hintStyle: const TextStyle(fontSize: 14), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: const BorderSide(color: Colors.transparent, width: 2)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: const BorderSide(color: Colors.transparent, width: 2)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: const BorderSide(color: Colors.transparent, width: 2))),
    dialogTheme: DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)), elevation: 1, backgroundColor: LightThemeColors.dialogbackground),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: LightThemeColors.primary, foregroundColor: Colors.white, splashColor: LightThemeColors.primary, hoverColor: LightThemeColors.primary, focusColor: LightThemeColors.primary, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))),
    splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
    splashColor: Colors.grey[200],
    highlightColor: Colors.grey[100],
    tooltipTheme: TooltipThemeData(textStyle: const TextStyle(color: Colors.white, fontSize: 18), decoration: BoxDecoration(color: LightThemeColors.primary, borderRadius: BorderRadius.circular(borderRadius))),
    dividerTheme: const DividerThemeData(color: LightThemeColors.grey, thickness: 2),
    
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory, shape: WidgetStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)))))));
ThemeData dark = ThemeData(
  primaryColor: DarkThemeColors.primary,
  colorScheme: ColorScheme.fromSeed(seedColor: DarkThemeColors.primary),
  dividerColor: DarkThemeColors.grey,
  textTheme: const TextTheme(
      bodyLarge: TextStyle(color: DarkThemeColors.darkBlue),
      bodyMedium: TextStyle(color: DarkThemeColors.darkBlue),
      bodySmall: TextStyle(color: DarkThemeColors.darkBlue),
      displaySmall: TextStyle(color: DarkThemeColors.darkBlue),
      displayMedium: TextStyle(color: DarkThemeColors.darkBlue),
      displayLarge: TextStyle(color: DarkThemeColors.darkBlue),
      headlineLarge: TextStyle(color: DarkThemeColors.darkBlue),
      headlineMedium: TextStyle(color: DarkThemeColors.darkBlue),
      headlineSmall: TextStyle(color: DarkThemeColors.darkBlue),
      titleMedium: TextStyle(color: DarkThemeColors.darkBlue),
      titleLarge: TextStyle(
          color: DarkThemeColors.darkBlue,
          fontSize: 36,
          fontWeight: FontWeight.bold),
      titleSmall: TextStyle(color: DarkThemeColors.darkBlue)),
  scaffoldBackgroundColor: DarkThemeColors.background,
  dialogBackgroundColor: DarkThemeColors.dialogbackground,
  cardTheme: const CardTheme(elevation: 2, color: DarkThemeColors.second),
  iconTheme: const IconThemeData(color: DarkThemeColors.primary),
  iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
          iconColor: WidgetStateProperty.all<Color>(DarkThemeColors.primary),
          iconSize: WidgetStateProperty.all<double>(30),
          splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory)),
  switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all<Color>(DarkThemeColors.primary),
      trackColor: WidgetStateProperty.all<Color>(
          DarkThemeColors.primary.withAlpha(50))),
  radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all<Color>(DarkThemeColors.primary)),
  primaryIconTheme: const IconThemeData(color: DarkThemeColors.primary),
  appBarTheme: const AppBarTheme(
      elevation: 0,
      actionsIconTheme: IconThemeData(color: Colors.white),
      backgroundColor: DarkThemeColors.primary,
      iconTheme: IconThemeData(color: Colors.white, size: 30),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
  scrollbarTheme: const ScrollbarThemeData(
      radius: Radius.circular(24),
      thumbColor: WidgetStatePropertyAll(Colors.grey)),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          elevation: WidgetStateProperty.all<double>(0),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius))))),
  inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: DarkThemeColors.darkGrey,
      suffixIconColor: DarkThemeColors.primary,
      fillColor: Colors.white,
      filled: true,
      iconColor: DarkThemeColors.primary,
      contentPadding:
          const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      floatingLabelStyle: const TextStyle(color: DarkThemeColors.primary),
      hintStyle: const TextStyle(fontSize: 14),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.transparent, width: 2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.transparent, width: 2)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.transparent, width: 2))),
  dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      elevation: 1,
      backgroundColor: DarkThemeColors.dialogbackground),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: DarkThemeColors.primary,
      foregroundColor: DarkThemeColors.second,
      splashColor: DarkThemeColors.primary,
      hoverColor: DarkThemeColors.primary,
      focusColor: DarkThemeColors.primary,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius))),
  splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
  splashColor: Colors.grey[200],
  highlightColor: Colors.grey[100],
  tooltipTheme: TooltipThemeData(
      textStyle: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: BoxDecoration(
          color: DarkThemeColors.primary,
          borderRadius: BorderRadius.circular(borderRadius))),
  dividerTheme:
      const DividerThemeData(color: DarkThemeColors.grey, thickness: 2),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(borderRadius)))))),
);

class AppThemeProvider with ChangeNotifier {
  bool _changeTheme = true;
  bool get changeTheme => _changeTheme;
  set changeTheme(bool valor) {
    _changeTheme = valor;
    notifyListeners();
  }

  void toogleTheme() {
    changeTheme = !changeTheme;
    Preferences.tema = changeTheme;
    notifyListeners();
  }
}
