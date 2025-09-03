import 'package:fluro/fluro.dart';
import 'package:rush_audio_chat/modules/main/page/main_page.dart';
import 'package:rush_audio_chat/modules/main/page/search_page.dart';
import 'package:rush_audio_chat/modules/main/page/user_detail_page.dart';

import '../../router/i_router.dart';

class MainRouter implements IRouterProvider{

  static String mainPage = '/main';
  static String searchPage = '/search';
  static String userDetailPage = '/userDetail';
  static String videoTagPage = '/videoTag';

  @override
  void initRouter(FluroRouter router) {
    router.define(mainPage, handler: Handler(handlerFunc: (_, __) => MainPage()));
    router.define(searchPage, handler: Handler(handlerFunc: (_, __) => const SearchPage()));
    router.define(userDetailPage, handler: Handler(handlerFunc: (context, params) {
      final userId = params['userId']?.first ?? '';
      return UserDetailPage(userId: userId);
    }));
    // router.define(videoTagPage, handler: Handler(handlerFunc: (_, __) => VideoTagPage()));
    // router.define(shopSettingPage, handler: Handler(handlerFunc: (_, __) => const ShopSettingPage()));
    // router.define(messagePage, handler: Handler(handlerFunc: (_, __) => const MessagePage()));
    // router.define(freightConfigPage, handler: Handler(handlerFunc: (_, __) => const FreightConfigPage()));
    // router.define(addressSelectPage, handler: Handler(handlerFunc: (_, __) => const AddressSelectPage()));
    // router.define(inputTextPage, handler: Handler(handlerFunc: (context, params) {
    //   /// 类参数
    //   final args = context!.settings!.arguments! as InputTextPageArgumentsData;
    //   return InputTextPage(
    //     title: args.title,
    //     hintText: args.hintText,
    //     content: args.content,
    //     keyboardType: args.keyboardType,
    //   );
    // }));
  }
}
