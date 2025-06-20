import 'package:flutter/material.dart';
import 'package:gastos/utilities/preferences.dart';

class ThemaMain {
  static Color primary =  LightTheme.primary;
  static Color second =
      (Preferences.thema ? LightTheme.second : DarkTheme.second);
  static Color white = Colors.white;
  static Color black = Colors.black;

  static Color green = (Preferences.thema ? LightTheme.green : DarkTheme.green);
  static Color red = (Preferences.thema ? LightTheme.red : DarkTheme.red);
  static Color yellow =
      (Preferences.thema ? LightTheme.yellow : DarkTheme.yellow);
  static Color purple =
      (Preferences.thema ? LightTheme.purple : DarkTheme.purple);

  static Color background =
      (Preferences.thema ? LightTheme.background : DarkTheme.background);
  static Color dialogbackground = (Preferences.thema
      ? LightTheme.dialogbackground
      : DarkTheme.dialogbackground);
  static Color darkGrey =
      (Preferences.thema ? LightTheme.darkGrey : DarkTheme.darkGrey);
  static Color darkBlue =
      (Preferences.thema ? LightTheme.darkBlue : DarkTheme.darkBlue);

  static Color grey = (Preferences.thema ? LightTheme.grey : DarkTheme.grey);
}

class LightTheme {
  static const primary = Color.fromARGB(255, 4, 142, 223);
  static const second = Color.fromARGB(255, 246, 247, 247);

  static const green = Color.fromARGB(255, 1, 207, 53);
  static const red = Color.fromARGB(255, 231, 20, 38);
  static const yellow = Color.fromARGB(255, 235, 210, 4);
  static const purple = Color.fromARGB(255, 106, 20, 218);

  static const background = Color.fromARGB(255, 238, 244, 245);
  static const dialogbackground = Color.fromARGB(255, 224, 241, 239);
  static const darkGrey = Color.fromARGB(255, 119, 122, 133);
  static const darkBlue = Color.fromARGB(255, 0, 36, 84);

  static const grey = Color.fromARGB(255, 206, 210, 212);
}

class DarkTheme {
  static const primary = Color.fromARGB(255, 53, 198, 255);
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
