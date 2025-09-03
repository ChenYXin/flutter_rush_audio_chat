// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get title_home {
    return Intl.message('Home', name: 'title_home', desc: '', args: []);
  }

  /// `Recommend`
  String get title_Recommend {
    return Intl.message(
      'Recommend',
      name: 'title_Recommend',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get title_chat {
    return Intl.message('Chat', name: 'title_chat', desc: '', args: []);
  }

  /// `Profile`
  String get title_profile {
    return Intl.message('Profile', name: 'title_profile', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Language Selection`
  String get language_selection {
    return Intl.message('Language Selection', name: 'language_selection', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `User Nickname`
  String get profile_user_nickname {
    return Intl.message('User Nickname', name: 'profile_user_nickname', desc: '', args: []);
  }

  /// `ID: {userId}`
  String get profile_user_id {
    return Intl.message('ID: {userId}', name: 'profile_user_id', desc: '', args: []);
  }

  /// `Coins`
  String get profile_coins {
    return Intl.message('Coins', name: 'profile_coins', desc: '', args: []);
  }

  /// `Diamonds`
  String get profile_diamonds {
    return Intl.message('Diamonds', name: 'profile_diamonds', desc: '', args: []);
  }

  /// `Likes`
  String get profile_likes {
    return Intl.message('Likes', name: 'profile_likes', desc: '', args: []);
  }

  /// `Quick Actions`
  String get profile_quick_actions {
    return Intl.message('Quick Actions', name: 'profile_quick_actions', desc: '', args: []);
  }

  /// `My Wallet`
  String get profile_my_wallet {
    return Intl.message('My Wallet', name: 'profile_my_wallet', desc: '', args: []);
  }

  /// `My Photos`
  String get profile_my_photos {
    return Intl.message('My Photos', name: 'profile_my_photos', desc: '', args: []);
  }

  /// `My Videos`
  String get profile_my_videos {
    return Intl.message('My Videos', name: 'profile_my_videos', desc: '', args: []);
  }

  /// `My Favorites`
  String get profile_my_favorites {
    return Intl.message('My Favorites', name: 'profile_my_favorites', desc: '', args: []);
  }

  /// `Personal Info`
  String get profile_personal_info {
    return Intl.message('Personal Info', name: 'profile_personal_info', desc: '', args: []);
  }

  /// `Edit personal profile`
  String get profile_personal_info_subtitle {
    return Intl.message('Edit personal profile', name: 'profile_personal_info_subtitle', desc: '', args: []);
  }

  /// `Account Security`
  String get profile_account_security {
    return Intl.message('Account Security', name: 'profile_account_security', desc: '', args: []);
  }

  /// `Password, privacy settings`
  String get profile_account_security_subtitle {
    return Intl.message('Password, privacy settings', name: 'profile_account_security_subtitle', desc: '', args: []);
  }

  /// `Notifications`
  String get profile_notifications {
    return Intl.message('Notifications', name: 'profile_notifications', desc: '', args: []);
  }

  /// `Push, reminder settings`
  String get profile_notifications_subtitle {
    return Intl.message('Push, reminder settings', name: 'profile_notifications_subtitle', desc: '', args: []);
  }

  /// `More setting options`
  String get profile_settings_subtitle {
    return Intl.message('More setting options', name: 'profile_settings_subtitle', desc: '', args: []);
  }

  /// `Help & Feedback`
  String get profile_help_feedback {
    return Intl.message('Help & Feedback', name: 'profile_help_feedback', desc: '', args: []);
  }

  /// `FAQ, feedback`
  String get profile_help_feedback_subtitle {
    return Intl.message('FAQ, feedback', name: 'profile_help_feedback_subtitle', desc: '', args: []);
  }

  /// `Theme Color`
  String get theme_color {
    return Intl.message('Theme Color', name: 'theme_color', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message('Privacy Policy', name: 'privacy_policy', desc: '', args: []);
  }

  /// `Legal Notice`
  String get legal_notice {
    return Intl.message('Legal Notice', name: 'legal_notice', desc: '', args: []);
  }

  /// `Version Info`
  String get version_info {
    return Intl.message('Version Info', name: 'version_info', desc: '', args: []);
  }

  /// `Nickname`
  String get nickname {
    return Intl.message('Nickname', name: 'nickname', desc: '', args: []);
  }

  /// `Page Not Found`
  String get not_found_title {
    return Intl.message('Page Not Found', name: 'not_found_title', desc: '', args: []);
  }

  /// `Sorry, the page you are looking for does not exist`
  String get not_found_subtitle {
    return Intl.message('Sorry, the page you are looking for does not exist', name: 'not_found_subtitle', desc: '', args: []);
  }

  /// `The page may have been moved, deleted, or you entered the wrong URL`
  String get not_found_description {
    return Intl.message('The page may have been moved, deleted, or you entered the wrong URL', name: 'not_found_description', desc: '', args: []);
  }

  /// `Back to Home`
  String get back_to_home {
    return Intl.message('Back to Home', name: 'back_to_home', desc: '', args: []);
  }

  /// `Back to Previous`
  String get back_to_previous {
    return Intl.message('Back to Previous', name: 'back_to_previous', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
