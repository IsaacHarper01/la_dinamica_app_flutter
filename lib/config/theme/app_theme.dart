import 'package:flutter/material.dart';

const colorList = <Color>[
  Color(0XFF06141B),
  Color(0XFF11212D),
  Color(0XFF253745),
  Color(0XFF4A5C6A),
  Color(0XFF51829B),
  Color(0XFF9BA8AB),
  Color(0XFFCCD0CF),
  Color.fromARGB(255, 221, 216, 225),
  Color.fromARGB(255, 243, 238, 243),
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0, 'Selected color must be greater than 0'),
        assert(selectedColor < colorList.length,
            'Selected color must be less or equal than ${colorList.length - 1}');

  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      colorSchemeSeed: colorList[selectedColor],
      appBarTheme: const AppBarTheme(centerTitle: false));
}
