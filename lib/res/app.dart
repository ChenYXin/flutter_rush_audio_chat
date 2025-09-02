
import 'package:flutter/material.dart';

/// 字体
const String fontFamily = "MadimiOne";

/// 全局context
GlobalKey<NavigatorState> navigatorKey = GlobalKey();

/// 圆角背景
class svBoxDecoration{
  static BoxDecoration white = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Colors.white,
  );

  static BoxDecoration grey = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    color: Colors.grey,
  );

  // static BoxDecoration colorPrimary = BoxDecoration(
  //   borderRadius: BorderRadius.all(Radius.circular(10)),
  //   color: navigatorKey.currentState!.context.watch<MyColor>().colorPrimary,
  // );
}

/// 图片路径
const String imgSplash = "assets/img/splash.png";
const String logo = "assets/img/1.jpg";
