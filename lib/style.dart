import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var theme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 5, selectedItemColor: Colors.black),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(backgroundColor: Colors.grey)),
    textTheme: GoogleFonts.juaTextTheme(),
    iconTheme: IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(
        textTheme: TextTheme(
            titleSmall: TextStyle(
          fontFamily: GoogleFonts.juaTextTheme().toString(),
          fontWeight: FontWeight.normal,
        )),
        color: Colors.white,
        elevation: 1,
        actionsIconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.juaTextTheme().toString(),
          color: Color.fromRGBO(0, 0, 0, 1),
          fontSize: 25,
        )));
