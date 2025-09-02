import 'package:flutter/material.dart';

class MyColor extends ChangeNotifier {
  MaterialColor color=colors[0];

  MyColor() {
   color = colors[0];
  }

  void setColor(int index) {
    color = colors[index];
    notifyListeners();
  }

  ///随主题动态变化
  MaterialColor get colorPrimary => color;
}

///自定义的主题色
List<MaterialColor> colors = [
  Colors.red,
  primaryBlack,
  Colors.purple,
  Colors.cyan,
  Colors.blue,
  Colors.amber,
  Colors.green,
];

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    // 50: Color(0xFF000000),
    // 100: Color(0xFF000000),
    // 200: Color(0xFF000000),
    // 300: Color(0xFF000000),
    // 400: Color(0xFF000000),
    // 500: Color(_blackPrimaryValue),
    // 600: Color(0xFF000000),
    // 700: Color(0xFF000000),
    // 800: Color(0xFF000000),
    // 900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

///背景颜色
const Color background = Color(0xfff4f4f4);