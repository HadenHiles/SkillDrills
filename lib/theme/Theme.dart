import 'package:flutter/material.dart';

class SkillDrillsTheme {
  SkillDrillsTheme._();

  static final ThemeData lightTheme = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: Color.fromRGBO(2, 164, 221, 1),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black87,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      onPrimary: Colors.black87,
      primaryVariant: Color(0xffF7F7F7),
      secondary: Color.fromRGBO(2, 164, 221, 1),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.black54,
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.black87,
      ),
      headline2: TextStyle(
        color: Colors.black87,
      ),
      headline3: TextStyle(
        color: Colors.black87,
      ),
      bodyText1: TextStyle(
        color: Colors.black87,
      ),
      bodyText2: TextStyle(
        color: Colors.black87,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    backgroundColor: Color(0xff222222),
    primaryColor: Color.fromRGBO(2, 164, 221, 1),
    scaffoldBackgroundColor: Color(0xff1A1A1A),
    appBarTheme: AppBarTheme(
      color: Colors.black87,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.black87,
      onPrimary: Colors.white,
      primaryVariant: Colors.black,
      secondary: Color.fromRGBO(2, 164, 221, 1),
    ),
    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.white,
      ),
      headline2: TextStyle(
        color: Colors.white,
      ),
      headline3: TextStyle(
        color: Colors.white54,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        color: Colors.white54,
      ),
    ),
  );
}
