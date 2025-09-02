import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rush_audio_chat/res/app.dart';
import 'package:rush_audio_chat/router/not_found_page.dart';
import 'package:rush_audio_chat/router/routers.dart';
import 'package:rush_audio_chat/splash_page.dart';
import 'package:rush_audio_chat/util/handle_error_utils.dart';

import 'commom/my_color.dart';
import 'commom/my_language.dart';
import 'generated/l10n.dart';

Future<void> main() async{
  /// 异常处理
  handleError(() async {
    /// 确保初始化完成
    WidgetsFlutterBinding.ensureInitialized();

    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    /// sp初始化
    // await SpUtil.getInstance();

    // runApp(MyApp());

    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => MyColor()),
      ChangeNotifierProvider(create: (context) => MyLanguage()),
    ],child: MyApp(),));
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key}){
    Routes.initRoutes();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates:const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _listenerLocal(context.watch<MyLanguage>().language),
      supportedLocales: S.delegate.supportedLocales,
      home: const SplashPage(),
      onGenerateRoute: Routes.router.generator,
      // routes: {
      //   "home": (context) => HomePage(),
      // },
      /// 因为使用了fluro，这里设置主要针对Web
      onUnknownRoute: (_) {
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => const NotFoundPage(),
        );
      },
      theme: ThemeData(
        fontFamily: 'MadimiOne',
      ),
    );
  }

  _listenerLocal(String lag) {
    if (lag == "zh") {
      return const Locale('zh','CN');
    } else if (lag == "en") {
      return const Locale('en','US');
    } else if (lag == "ja") {
      return Locale('ja');
    }else if (lag == "au") {
      return Locale('au','AU');
    } else if(lag == "ko"){
      return Locale('ko','KR');
    }
  }
}
