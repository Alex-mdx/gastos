import 'package:flutter/material.dart';
import 'package:gastos/utilities/preferences.dart';

class ThemaMain {
  static Color primary =
      (Preferences.thema ? LightThemeColors.primary : DarkThemeColors.primary);
  static Color second =
      (Preferences.thema ? LightThemeColors.second : DarkThemeColors.second);

  static Color green =
      (Preferences.thema ? LightThemeColors.green : DarkThemeColors.green);
  static Color red =
      (Preferences.thema ? LightThemeColors.red : DarkThemeColors.red);
  static Color yellow =
      (Preferences.thema ? LightThemeColors.yellow : DarkThemeColors.yellow);
  static Color purple =
      (Preferences.thema ? LightThemeColors.purple : DarkThemeColors.purple);

  static Color background = (Preferences.thema
      ? LightThemeColors.background
      : DarkThemeColors.background);
  static Color dialogbackground = (Preferences.thema
      ? LightThemeColors.dialogbackground
      : DarkThemeColors.dialogbackground);
  static Color darkGrey = (Preferences.thema
      ? LightThemeColors.darkGrey
      : DarkThemeColors.darkGrey);
  static Color darkBlue = (Preferences.thema
      ? LightThemeColors.darkBlue
      : DarkThemeColors.darkBlue);

  static Color grey =
      (Preferences.thema ? LightThemeColors.grey : DarkThemeColors.grey);
}

class LightThemeColors {
  static const primary = Color.fromARGB(255, 4, 142, 223);
  static const second = Color.fromARGB(255, 241, 243, 243);

  static const green = Color.fromARGB(255, 1, 207, 53);
  static const red = Color.fromARGB(255, 231, 20, 38);
  static const yellow = Color.fromARGB(255, 235, 210, 4);
  static const purple = Color.fromARGB(255, 106, 20, 218);

  static const background = Color.fromARGB(255, 238, 241, 245);
  static const dialogbackground = Color.fromARGB(255, 237, 245, 244);
  static const darkGrey = Color.fromARGB(255, 119, 122, 133);
  static const darkBlue = Color.fromARGB(255, 0, 36, 84);

  static const grey = Color.fromARGB(255, 206, 210, 212);
}

class DarkThemeColors {
  static const primary = Color.fromARGB(255, 53, 225, 255);
  static const second = Color.fromARGB(255, 40, 42, 43);

  static const green = Color.fromARGB(255, 70, 255, 116);
  static const red = Color.fromARGB(255, 255, 70, 86);
  static const yellow = Color.fromARGB(255, 255, 252, 86);
  static const purple = Color.fromARGB(255, 156, 80, 255);

  static const background = Color.fromARGB(255, 20, 20, 20);
  static const dialogbackground = Color.fromARGB(255, 29, 31, 31);
  static const darkGrey = Color.fromARGB(255, 220, 221, 224);
  static const darkBlue = Color.fromARGB(255, 172, 198, 233);

  static const grey = Color.fromARGB(255, 197, 199, 201);
}
