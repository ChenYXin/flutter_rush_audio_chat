import 'package:flutter/material.dart';

class MyLanguage with ChangeNotifier {
  String _language = "en";

  String get language => _language;

  void changeMode(String language) async {
    _language = language;
    notifyListeners();
    // SpUtil.putString("language", language);
  }
}

List<String> languages = ['en', 'es', 'th', 'pt', 'fr', 'hi', 'zh', 'zh_Hant'];
