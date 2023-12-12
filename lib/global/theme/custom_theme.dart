import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color/abs_theme_colors.dart';
import 'color/dark_app_colors.dart';
import 'color/light_app_colors.dart';

enum CustomTheme {
  dark(
    DarkAppColors(),
  ),
  light(
    LightAppColors(),
  );

  const CustomTheme(this.appColors);

  final AbstractThemeColors appColors;

  ThemeData get themeData {
    switch (this) {
      case CustomTheme.dark:
        return darkTheme;
      case CustomTheme.light:
        return lightTheme;
    }
  }
}

String fontFamily = 'sans';

TextTheme textTheme = TextTheme(
  titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: fontFamily),
  titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: fontFamily),
);

MaterialColor primarySwatchColor = Colors.lightBlue;

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: textTheme,
  fontFamily: 'sans',
  colorScheme: const ColorScheme.light(
    primary: Colors.white,
    secondary: Colors.black,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedItemColor: Colors.black,
  ),
  appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  textTheme: textTheme,
  fontFamily: 'sans',
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedItemColor: Colors.white,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.black,
    secondary: Colors.white,
    background: Colors.black,
  ),
  appBarTheme:
      const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
);
