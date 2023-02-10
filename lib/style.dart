import 'package:flutter/material.dart';

var theme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 5, selectedItemColor: Colors.black),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(backgroundColor: Colors.grey)),
    iconTheme: IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 1,
        actionsIconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1),
          fontSize: 25,
        )));
