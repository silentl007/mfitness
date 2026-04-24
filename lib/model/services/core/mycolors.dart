import 'package:flutter/material.dart';

class MyColors {
  Color primaryColor = const Color(0xffa4e562);
  Color lightprimaryColor = const Color(0XFFF0F4FF);
  Color formTextColor = const Color(0XFF555562);
  Color fadedGrey = const Color(0xFF555562);
  Color formHintColor = const Color(0XFF808080);
  Color yellow = const Color(0xFFFDB813);
  Color formBorder = const Color(0xffE9E9E9);
  Color lightgrey = const Color.fromARGB(255, 245, 245, 245);
  Color appBar = const Color(0xFF50CA00);
}

MyColors myColors = MyColors();

class LetterColorDecider {
  static const List<Color> _colorList = [
    Colors.blue,
    Colors.amber,
    Colors.purple,
    Colors.green,
    Colors.orange,
    Colors.indigo,
    Colors.pink,
    Color.fromARGB(255, 56, 53, 26),
    Colors.brown,
    Colors.teal,
    Color.fromARGB(255, 155, 165, 44),
    Colors.indigoAccent,
    Colors.deepOrange,
    Color(0xFF1565C0), // blue[700]
    Color(0xFFFFB300), // amber[700]
    Color(0xFF6A1B9A), // purple[700]
    Color(0xFF388E3C), // green[700]
    Color(0xFFF57C00), // orange[700]
    Color(0xFF283593), // indigo[700]
    Color(0xFFC2185B), // pink[700]
    Color(0xFFF9A825), // yellow[700]
    Color(0xFF5D4037), // brown[700]
    Color(0xFF00796B), // teal[700]
    Color.fromARGB(255, 128, 170, 1),
    Color(0xFF304FFE), // indigoAccent[700]
    Color(0xFFD84315), // deepOrange[700]
  ];

  /// Returns a color based on the first letter of the input string
  static Color getColor(String letter) {
    if (letter.isEmpty) return Colors.grey;
    final index = letter.toLowerCase().codeUnitAt(0) - 'a'.codeUnitAt(0);
    if (index < 0 || index >= _colorList.length) return Colors.grey;
    return _colorList[index];
  }
}
