import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush_audio_chat/generated/l10n.dart';

import 'package:rush_audio_chat/commom/my_language.dart';

import '../../../commom/my_color.dart';

class LanguageSelectionPage extends StatefulWidget {
  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  // List<String> languages = ['en', 'es', 'th', 'pt', 'fr', 'hi', 'zh', 'zh_Hant'];
  // late String selectedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // selectedLanguage = Localizations.localeOf(context).languageCode;
  }

  // void _changeLanguage(String languageCode) {
  // Locale newLocale = Locale(languageCode);
  // S.load(newLocale).then((value) {
  //   setState(() {
  //     selectedLanguage = languageCode;
  //   });
  // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.watch<MyColor>().colorPrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          S.of(context).language,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          String language = languages[index];
          return ListTile(
            title: Text(language),
            trailing: context.watch<MyLanguage>().language == language
                ? Icon(Icons.check, color: context.watch<MyColor>().colorPrimary)
                : null,
            onTap: () {
              // _changeLanguage(language);
              context.read<MyLanguage>().changeMode(language);
            },
          );
        },
      ),
    );
  }
}
