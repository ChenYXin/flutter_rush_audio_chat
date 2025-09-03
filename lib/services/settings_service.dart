import '../database/database_helper.dart';

/// 设置持久化服务类
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  static SettingsService get instance => _instance;
  
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  SettingsService._internal();

  // 设置键常量
  static const String keyLanguage = 'language';
  static const String keyThemeColorIndex = 'theme_color_index';
  static const String keyDarkMode = 'dark_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyVibrationEnabled = 'vibration_enabled';
  static const String keyFontSize = 'font_size';

  /// 保存语言设置
  Future<void> saveLanguage(String language) async {
    await _dbHelper.saveSetting(keyLanguage, language);
  }

  /// 获取语言设置
  Future<String> getLanguage() async {
    return await _dbHelper.getSetting(keyLanguage) ?? 'zh';
  }

  /// 保存主题颜色索引
  Future<void> saveThemeColorIndex(int index) async {
    await _dbHelper.saveSetting(keyThemeColorIndex, index.toString());
  }

  /// 获取主题颜色索引
  Future<int> getThemeColorIndex() async {
    final indexStr = await _dbHelper.getSetting(keyThemeColorIndex);
    return int.tryParse(indexStr ?? '0') ?? 0;
  }

  /// 保存深色模式设置
  Future<void> saveDarkMode(bool isDarkMode) async {
    await _dbHelper.saveSetting(keyDarkMode, isDarkMode.toString());
  }

  /// 获取深色模式设置
  Future<bool> getDarkMode() async {
    final darkModeStr = await _dbHelper.getSetting(keyDarkMode);
    return darkModeStr == 'true';
  }

  /// 保存通知设置
  Future<void> saveNotificationsEnabled(bool enabled) async {
    await _dbHelper.saveSetting(keyNotificationsEnabled, enabled.toString());
  }

  /// 获取通知设置
  Future<bool> getNotificationsEnabled() async {
    final enabledStr = await _dbHelper.getSetting(keyNotificationsEnabled);
    return enabledStr != 'false'; // 默认开启
  }

  /// 保存声音设置
  Future<void> saveSoundEnabled(bool enabled) async {
    await _dbHelper.saveSetting(keySoundEnabled, enabled.toString());
  }

  /// 获取声音设置
  Future<bool> getSoundEnabled() async {
    final enabledStr = await _dbHelper.getSetting(keySoundEnabled);
    return enabledStr != 'false'; // 默认开启
  }

  /// 保存震动设置
  Future<void> saveVibrationEnabled(bool enabled) async {
    await _dbHelper.saveSetting(keyVibrationEnabled, enabled.toString());
  }

  /// 获取震动设置
  Future<bool> getVibrationEnabled() async {
    final enabledStr = await _dbHelper.getSetting(keyVibrationEnabled);
    return enabledStr != 'false'; // 默认开启
  }

  /// 保存字体大小
  Future<void> saveFontSize(double fontSize) async {
    await _dbHelper.saveSetting(keyFontSize, fontSize.toString());
  }

  /// 获取字体大小
  Future<double> getFontSize() async {
    final fontSizeStr = await _dbHelper.getSetting(keyFontSize);
    return double.tryParse(fontSizeStr ?? '16.0') ?? 16.0;
  }

  /// 获取所有设置
  Future<Map<String, dynamic>> getAllSettings() async {
    final settings = await _dbHelper.getAllSettings();
    
    return {
      keyLanguage: settings[keyLanguage] ?? 'zh',
      keyThemeColorIndex: int.tryParse(settings[keyThemeColorIndex] ?? '0') ?? 0,
      keyDarkMode: settings[keyDarkMode] == 'true',
      keyNotificationsEnabled: settings[keyNotificationsEnabled] != 'false',
      keySoundEnabled: settings[keySoundEnabled] != 'false',
      keyVibrationEnabled: settings[keyVibrationEnabled] != 'false',
      keyFontSize: double.tryParse(settings[keyFontSize] ?? '16.0') ?? 16.0,
    };
  }

  /// 重置所有设置为默认值
  Future<void> resetAllSettings() async {
    await saveLanguage('zh');
    await saveThemeColorIndex(0);
    await saveDarkMode(false);
    await saveNotificationsEnabled(true);
    await saveSoundEnabled(true);
    await saveVibrationEnabled(true);
    await saveFontSize(16.0);
  }

  /// 导出设置（用于备份）
  Future<Map<String, String>> exportSettings() async {
    return await _dbHelper.getAllSettings();
  }

  /// 导入设置（用于恢复）
  Future<void> importSettings(Map<String, String> settings) async {
    for (final entry in settings.entries) {
      await _dbHelper.saveSetting(entry.key, entry.value);
    }
  }
}
