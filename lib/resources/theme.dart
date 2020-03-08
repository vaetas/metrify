import 'package:flutter/material.dart';

class AppTheme {
  static const String fontFamily = 'Inter';

  static const double appBarFontSize = 22;
  static const FontWeight appBarFontWeight = FontWeight.w700;
  static const double appBarHeight = 85;

  static const double appBarElevationLow = 0;
  static const double appBarElevationHigh = 4;

  static const Color backgroundColor = Colors.white;

  static const PageTransitionsTheme _pageTransitionTheme = PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
  });

  static const _dividerTheme = DividerThemeData(
    thickness: 1,
    indent: 0,
    space: 4,
  );

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: fontFamily,
      accentColor: Colors.teal,
      primaryColor: Colors.teal,
      cardColor: Colors.black12,
      textTheme: TextTheme(
        title: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
        display1: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black.withOpacity(0.75),
          fontSize: 18,
        ),
        headline: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      scaffoldBackgroundColor: backgroundColor,
      pageTransitionsTheme: _pageTransitionTheme,
      appBarTheme: AppBarTheme(
        color: backgroundColor,
        brightness: Brightness.light,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontFamily: fontFamily,
            fontSize: appBarFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
      ),
      dividerTheme: _dividerTheme,
      dividerColor: Colors.black12,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.teal,
        textTheme: ButtonTextTheme.primary,
      ));

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: Colors.black,
    accentColor: Colors.tealAccent,
    cardColor: Colors.grey.withOpacity(0.5),
    primaryColor: Colors.white,
    pageTransitionsTheme: _pageTransitionTheme,
    textTheme: TextTheme(
      title: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: Colors.white,
      ),
      display1: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 18,
      ),
      headline: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.black,
      brightness: Brightness.dark,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.white,
          fontFamily: fontFamily,
          fontSize: appBarFontSize,
          fontWeight: appBarFontWeight,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
      backgroundColor: Colors.tealAccent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    dividerTheme: _dividerTheme.copyWith(
      color: Colors.white.withOpacity(0.2),
    ),
  );
}
