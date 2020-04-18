/*
 * Metrify: Track Your Metrics
 * Copyright (C) 2020  Vojtech Pavlovsky
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';

class AppTheme {
  static const String fontFamily = 'Inter';

  static const double appBarFontSize = 22;
  static const FontWeight appBarFontWeight = FontWeight.w700;
  static const double appBarHeight = 85;

  static const double appBarElevationLow = 0;
  static const double appBarElevationHigh = 4;

  static const Color backgroundColor = Colors.white;

  static const double bottomBarIconSize = 20;

  static const PageTransitionsTheme _pageTransitionTheme =
      PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
  });

  static final _dividerTheme = DividerThemeData(
    thickness: 1,
    indent: 0,
    space: 4,
    color: black.withOpacity(0.2),
  );

  static const Color black = Color(0xFF14151E);

  static get lightTheme => ThemeData(
        brightness: Brightness.light,
        fontFamily: fontFamily,
        accentColor: Colors.teal,
        primaryColor: Color(0xFF14151D),
        cardColor: Color(0xffe2e3ec),
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
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF14151E),
        ),
        dividerTheme: _dividerTheme,
        dividerColor: black.withOpacity(0.0),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0xffe2e3ec),
          filled: true,
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.70),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      );

  static get darkTheme => ThemeData(
        brightness: Brightness.dark,
        fontFamily: fontFamily,
        scaffoldBackgroundColor: Color(0xFF14151E),
        accentColor: Colors.tealAccent,
        cardColor: Colors.grey.withOpacity(0.5),
        primaryColor: Colors.white,
        pageTransitionsTheme: _pageTransitionTheme,
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFFEFFFE),
          textTheme: ButtonTextTheme.primary,
        ),
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
          button: TextStyle(
            color: Colors.black,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xFF14151E),
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
          backgroundColor: Color(0xFFFEFFFE),
        ),
        dividerTheme: _dividerTheme.copyWith(
          color: Colors.white.withOpacity(0.2),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white.withOpacity(0.2),
          focusColor: Colors.red,
          hoverColor: Colors.red,
          filled: true,
          enabledBorder: UnderlineInputBorder(
//            borderSide: BorderSide(
//              color: Colors.white.withOpacity(0.5),
//            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
          ),
          focusedBorder: OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(
                color: Colors.white,
              )),
        ),
      );
}
