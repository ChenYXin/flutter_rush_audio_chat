import 'package:fluro/fluro.dart';
import 'package:rush_audio_chat/modules/settings/page/language_selection_page.dart';
import 'package:rush_audio_chat/modules/settings/page/settings_detail_page.dart';
import 'package:rush_audio_chat/router/i_router.dart';

class SettingRouter implements IRouterProvider{

  static String settingsDetailPage = '/settingsDetail';
  static String languageSelectionPage = "/language_selection";

  @override
  void initRouter(FluroRouter router) {
    router.define(settingsDetailPage, handler: Handler(handlerFunc: (_, __) => SettingsDetailPage()));
    router.define(languageSelectionPage, handler: Handler(handlerFunc: (_, __) => LanguageSelectionPage()));
  }
}
