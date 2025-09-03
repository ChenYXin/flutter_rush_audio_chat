import 'package:flutter/material.dart';
import '../../../services/settings_service.dart';

/// 设置页面的ViewModel
class SettingsViewModel with ChangeNotifier {
  /// 当前选择的语言
  String _currentLanguage = 'zh';
  String get currentLanguage => _currentLanguage;

  /// 当前主题颜色索引
  int _currentThemeColorIndex = 0;
  int get currentThemeColorIndex => _currentThemeColorIndex;

  /// 是否开启深色模式
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  /// 是否开启通知
  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  /// 是否开启声音
  bool _soundEnabled = true;
  bool get soundEnabled => _soundEnabled;

  /// 是否开启震动
  bool _vibrationEnabled = true;
  bool get vibrationEnabled => _vibrationEnabled;

  /// 字体大小
  double _fontSize = 16.0;
  double get fontSize => _fontSize;

  /// 应用版本
  String _appVersion = '1.0.0';
  String get appVersion => _appVersion;

  /// 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 设置服务
  final SettingsService _settingsService = SettingsService.instance;

  /// 构造函数
  SettingsViewModel() {
    _loadSettingsFromDatabase();
  }

  /// 从数据库加载设置
  Future<void> _loadSettingsFromDatabase() async {
    try {
      _isLoading = true;
      notifyListeners();

      final settings = await _settingsService.getAllSettings();

      _currentLanguage = settings[SettingsService.keyLanguage] ?? 'zh';
      _currentThemeColorIndex = settings[SettingsService.keyThemeColorIndex] ?? 0;
      _isDarkMode = settings[SettingsService.keyDarkMode] ?? false;
      _notificationsEnabled = settings[SettingsService.keyNotificationsEnabled] ?? true;
      _soundEnabled = settings[SettingsService.keySoundEnabled] ?? true;
      _vibrationEnabled = settings[SettingsService.keyVibrationEnabled] ?? true;
      _fontSize = settings[SettingsService.keyFontSize] ?? 16.0;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '加载设置失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 可选的主题颜色
  final List<Color> _themeColors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
  ];
  List<Color> get themeColors => _themeColors;

  /// 获取当前主题颜色
  Color get currentThemeColor => _themeColors[_currentThemeColorIndex];

  /// 获取当前语言的显示名称
  String getCurrentLanguageDisplayName() {
    switch (_currentLanguage) {
      case 'zh':
        return '简体中文';
      case 'en':
        return 'English';
      default:
        return '简体中文';
    }
  }

  /// 切换语言
  Future<void> changeLanguage(String languageCode) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _settingsService.saveLanguage(languageCode);
      _currentLanguage = languageCode;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '语言切换失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 切换主题颜色
  Future<void> changeThemeColor(int colorIndex) async {
    if (colorIndex >= 0 && colorIndex < _themeColors.length) {
      try {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();

        await _settingsService.saveThemeColorIndex(colorIndex);
        _currentThemeColorIndex = colorIndex;

        _isLoading = false;
        notifyListeners();
      } catch (e) {
        _errorMessage = '主题颜色更新失败: ${e.toString()}';
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// 切换深色模式
  Future<void> toggleDarkMode() async {
    try {
      _isDarkMode = !_isDarkMode;
      await _settingsService.saveDarkMode(_isDarkMode);
      notifyListeners();
    } catch (e) {
      _errorMessage = '深色模式设置失败: ${e.toString()}';
      notifyListeners();
    }
  }

  /// 切换通知开关
  Future<void> toggleNotifications() async {
    try {
      _notificationsEnabled = !_notificationsEnabled;
      await _settingsService.saveNotificationsEnabled(_notificationsEnabled);
      notifyListeners();
    } catch (e) {
      _errorMessage = '通知设置失败: ${e.toString()}';
      notifyListeners();
    }
  }

  /// 切换声音开关
  Future<void> toggleSound() async {
    try {
      _soundEnabled = !_soundEnabled;
      await _settingsService.saveSoundEnabled(_soundEnabled);
      notifyListeners();
    } catch (e) {
      _errorMessage = '声音设置失败: ${e.toString()}';
      notifyListeners();
    }
  }

  /// 切换震动开关
  Future<void> toggleVibration() async {
    try {
      _vibrationEnabled = !_vibrationEnabled;
      await _settingsService.saveVibrationEnabled(_vibrationEnabled);
      notifyListeners();
    } catch (e) {
      _errorMessage = '震动设置失败: ${e.toString()}';
      notifyListeners();
    }
  }

  /// 设置字体大小
  Future<void> setFontSize(double size) async {
    if (size >= 12.0 && size <= 24.0) {
      try {
        _fontSize = size;
        await _settingsService.saveFontSize(size);
        notifyListeners();
      } catch (e) {
        _errorMessage = '字体大小设置失败: ${e.toString()}';
        notifyListeners();
      }
    }
  }

  /// 重置所有设置
  Future<void> resetAllSettings() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _settingsService.resetAllSettings();

      _currentLanguage = 'zh';
      _currentThemeColorIndex = 0;
      _isDarkMode = false;
      _notificationsEnabled = true;
      _soundEnabled = true;
      _vibrationEnabled = true;
      _fontSize = 16.0;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '重置设置失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 检查更新
  Future<bool> checkForUpdates() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 模拟检查更新
      await Future.delayed(const Duration(seconds: 2));
      
      _isLoading = false;
      notifyListeners();
      
      // 模拟没有更新
      return false;
      
    } catch (e) {
      _errorMessage = '检查更新失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 获取设置项的值显示
  String getSettingValueText(String itemType) {
    switch (itemType) {
      case 'language':
        return getCurrentLanguageDisplayName();
      case 'theme':
        return '主题 ${_currentThemeColorIndex + 1}';
      case 'font_size':
        return '${_fontSize.toInt()}sp';
      case 'version':
        return _appVersion;
      default:
        return '';
    }
  }

  /// 显示错误信息
  void showError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
