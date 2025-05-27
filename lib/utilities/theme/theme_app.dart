import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'theme_color.dart';

const double borderRadius = 24.0;
ThemeData light = ThemeData(
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
    cardTheme:
        const CardThemeData(elevation: 2, color: LightThemeColors.second),
    iconTheme: const IconThemeData(color: LightThemeColors.primary),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            iconColor: WidgetStateProperty.all<Color>(LightThemeColors.primary),
            iconSize: WidgetStateProperty.all<double>(24.sp),
            splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory)),
    switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all<Color>(LightThemeColors.primary),
        trackColor: WidgetStateProperty.all<Color>(
            LightThemeColors.primary.withAlpha(50))),
    radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all<Color>(LightThemeColors.primary)),
    primaryIconTheme: const IconThemeData(color: LightThemeColors.primary),
    appBarTheme: AppBarTheme(
        elevation: 0,
        actionsIconTheme: const IconThemeData(color: LightThemeColors.second),
        backgroundColor: const Color.fromARGB(255, 4, 106, 223),
        iconTheme: IconThemeData(color: LightThemeColors.second, size: 24.sp),
        titleTextStyle: const TextStyle(
            color: LightThemeColors.second, fontSize: 32, fontWeight: FontWeight.bold)),
    scrollbarTheme: const ScrollbarThemeData(
        radius: Radius.circular(24),
        thumbColor: WidgetStatePropertyAll(Colors.grey)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(LightThemeColors.second),
            elevation: WidgetStateProperty.all<double>(0),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))))),
    inputDecorationTheme: InputDecorationTheme(prefixIconColor: LightThemeColors.darkGrey, suffixIconColor: LightThemeColors.primary, fillColor: LightThemeColors.second, filled: true, iconColor: LightThemeColors.primary, contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20), floatingLabelStyle: const TextStyle(color: LightThemeColors.primary), hintStyle: const TextStyle(fontSize: 14), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: const BorderSide(color: Colors.transparent, width: 2)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: const BorderSide(color: Colors.transparent, width: 2)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: const BorderSide(color: Colors.transparent, width: 2))),
    dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)), elevation: 1, backgroundColor: LightThemeColors.dialogbackground),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: LightThemeColors.primary, foregroundColor: LightThemeColors.second, splashColor: LightThemeColors.primary, hoverColor: LightThemeColors.primary, focusColor: LightThemeColors.primary, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))),
    splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
    splashColor: LightThemeColors.grey,
    highlightColor: LightThemeColors.grey,
    tooltipTheme: TooltipThemeData(textStyle: const TextStyle(color: LightThemeColors.second, fontSize: 18), decoration: BoxDecoration(color: LightThemeColors.primary, borderRadius: BorderRadius.circular(borderRadius))),
    dividerTheme: const DividerThemeData(color: LightThemeColors.grey, thickness: 2),
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory, shape: WidgetStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)))))));
ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: DarkThemeColors.primary),
    dividerColor: DarkThemeColors.grey,
    textTheme: const TextTheme(
        bodyLarge: TextStyle(color: DarkThemeColors.grey),
        bodyMedium: TextStyle(color: DarkThemeColors.grey),
        bodySmall: TextStyle(color: DarkThemeColors.grey),
        displaySmall: TextStyle(color: DarkThemeColors.grey),
        displayMedium: TextStyle(color: DarkThemeColors.grey),
        displayLarge: TextStyle(color: DarkThemeColors.grey),
        headlineLarge: TextStyle(color: DarkThemeColors.grey),
        headlineMedium: TextStyle(color: DarkThemeColors.grey),
        headlineSmall: TextStyle(color: DarkThemeColors.grey),
        titleMedium: TextStyle(color: DarkThemeColors.grey),
        titleLarge: TextStyle(
            color: DarkThemeColors.grey,
            fontSize: 36,
            fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: DarkThemeColors.grey)),
    scaffoldBackgroundColor: DarkThemeColors.background,
    cardTheme:
        const CardThemeData(elevation: 2, color: DarkThemeColors.second),
    iconTheme: const IconThemeData(color: DarkThemeColors.primary),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            iconColor: WidgetStateProperty.all<Color>(DarkThemeColors.primary),
            iconSize: WidgetStateProperty.all<double>(24.sp),
            splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory)),
    switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all<Color>(DarkThemeColors.primary),
        trackColor: WidgetStateProperty.all<Color>(
            DarkThemeColors.primary.withAlpha(50))),
    radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all<Color>(DarkThemeColors.primary)),
    primaryIconTheme: const IconThemeData(color: DarkThemeColors.primary),
    appBarTheme: AppBarTheme(
        elevation: 0,
        actionsIconTheme: const IconThemeData(color: DarkThemeColors.second),
        backgroundColor: const Color.fromARGB(255, 4, 106, 223),
        iconTheme: IconThemeData(color: DarkThemeColors.second, size: 24.sp),
        titleTextStyle: const TextStyle(
            color: DarkThemeColors.second, fontSize: 32, fontWeight: FontWeight.bold)),
    scrollbarTheme: const ScrollbarThemeData(
        radius: Radius.circular(24),
        thumbColor: WidgetStatePropertyAll(DarkThemeColors.grey)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(DarkThemeColors.darkBlue),
            elevation: WidgetStateProperty.all<double>(0),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))))),
    inputDecorationTheme: InputDecorationTheme(prefixIconColor: DarkThemeColors.darkGrey, suffixIconColor: DarkThemeColors.primary, fillColor: DarkThemeColors.second, filled: true, iconColor: DarkThemeColors.primary, contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20), floatingLabelStyle: const TextStyle(color: DarkThemeColors.primary), hintStyle: const TextStyle(fontSize: 14), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: const BorderSide(color: Colors.transparent, width: 2)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: const BorderSide(color: Colors.transparent, width: 2)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: const BorderSide(color: Colors.transparent, width: 2))),
    dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)), elevation: 1, backgroundColor: DarkThemeColors.dialogbackground),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: DarkThemeColors.primary, foregroundColor: DarkThemeColors.second, splashColor: DarkThemeColors.primary, hoverColor: DarkThemeColors.primary, focusColor: DarkThemeColors.primary, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))),
    splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
    splashColor: DarkThemeColors.grey,
    highlightColor: DarkThemeColors.grey,
    tooltipTheme: TooltipThemeData(textStyle: const TextStyle(color: DarkThemeColors.second, fontSize: 18), decoration: BoxDecoration(color: DarkThemeColors.primary, borderRadius: BorderRadius.circular(borderRadius))),
    dividerTheme: const DividerThemeData(color: DarkThemeColors.grey, thickness: 2),
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory, shape: WidgetStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)))))));
