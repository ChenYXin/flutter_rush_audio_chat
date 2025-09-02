import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush_audio_chat/generated/l10n.dart';
import 'package:rush_audio_chat/res/app.dart';
import 'package:rush_audio_chat/router/fluro_navigator.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../../commom/my_color.dart';
import '../../../commom/my_language.dart';
import '../../../dialog/select_theme_color_dialog.dart';
import '../setting_router.dart';

class SettingsDetailPage extends StatefulWidget {
  const SettingsDetailPage({super.key});

  @override
  State<SettingsDetailPage> createState() => _SettingsDetailPageState();
}

class _SettingsDetailPageState extends State<SettingsDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: context.watch<MyColor>().colorPrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          S.of(context).settings,
          style: const TextStyle(fontFamily: fontFamily, fontSize: 18,color: Colors.white),
        ),
      ),
      body: Column(children: [_buildSettingList()]),
    );
  }
  Widget _buildSettingList() {
    return SettingsList(
      lightTheme: const SettingsThemeData(
          settingsListBackground: background),
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      sections: [
        SettingsSection(
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              onPressed: (context) {
                SelectThemeColorDialog(context: context).show();
              },
              trailing: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: context.watch<MyColor>().colorPrimary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(360),
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
              leading: Icon(
                Icons.color_lens,
                color: context.watch<MyColor>().colorPrimary,
              ),
              title: Text(
                "Theme Color",
                style: TextStyle(fontFamily: fontFamily, fontSize: 18),
              ),
            ),
            SettingsTile.navigation(
              onPressed: (context) {
                // 导航到语言页面
                NavigatorUtils.push(
                    context, SettingRouter.languageSelectionPage);
              },
              trailing: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Text(
                      context.watch<MyLanguage>().language,
                      style:
                      const TextStyle(fontFamily: fontFamily, fontSize: 18),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
              leading: Icon(
                Icons.language,
                color: context.watch<MyColor>().colorPrimary,
              ),
              title: Text(
                S.of(context).language,
                style: const TextStyle(fontFamily: fontFamily, fontSize: 18),
              ),
            ),
            SettingsTile.navigation(
              onPressed: (context) {
                // 导航到用户协议页面
                // NavigatorUtils.push(context, SettingRouter.userAgreementPage);
              },
              trailing: const Icon(Icons.keyboard_arrow_right),
              leading: Icon(
                Icons.privacy_tip,
                color: context.watch<MyColor>().colorPrimary,
              ),
              title: const Text(
                "Privacy Policy",
                style: TextStyle(fontFamily: fontFamily, fontSize: 18),
              ),
            ),
            SettingsTile.navigation(
              onPressed: (context) {
                // 导航到用户协议页面
                // NavigatorUtils.push(context, SettingRouter.userAgreementPage);
              },
              trailing: const Icon(Icons.keyboard_arrow_right),
              leading: Icon(
                Icons.gavel,
                color: context.watch<MyColor>().colorPrimary,
              ),
              title: const Text(
                "Legal Notice",
                style: TextStyle(fontFamily: fontFamily, fontSize: 18),
              ),
            ),
            SettingsTile.navigation(
              onPressed: (context) {
                // 导航到用户协议页面
                // NavigatorUtils.push(context, SettingRouter.userAgreementPage);
              },
              trailing: const Icon(Icons.keyboard_arrow_right),
              leading: Icon(
                Icons.info,
                color: context.watch<MyColor>().colorPrimary,
              ),
              title: const Text(
                "Version Info",
                style: TextStyle(fontFamily: fontFamily, fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

