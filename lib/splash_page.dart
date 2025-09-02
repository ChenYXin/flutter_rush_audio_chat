import 'package:flutter/material.dart';
import 'package:rush_audio_chat/res/app.dart';
import 'package:rush_audio_chat/router/fluro_navigator.dart';

import 'modules/main/main_router.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      //延时执行的代码
      // Navigator.popAndPushNamed(context, "home");
      NavigatorUtils.push(context,MainRouter.mainPage,replace: true,clearStack: true);
    });

    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          imgSplash,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
