import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import '../../../commom/my_language.dart';

/// 语言选择页面的ViewModel
class LanguageViewModel with ChangeNotifier {
  /// 当前选择的语言
  String _selectedLanguage = 'zh';
  String get selectedLanguage => _selectedLanguage;

  /// 原始语言（用于取消时恢复）
  String _originalLanguage = 'zh';
  String get originalLanguage => _originalLanguage;

  /// 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 语言切换成功状态
  bool _languageChanged = false;
  bool get languageChanged => _languageChanged;

  /// 是否显示应用按钮
  bool _showApplyButton = false;
  bool get showApplyButton => _showApplyButton;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 是否已被dispose
  bool _disposed = false;

  /// 数据库助手
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// 构造函数
  LanguageViewModel(String initialLanguage) {
    _selectedLanguage = initialLanguage;
    _originalLanguage = initialLanguage;
  }

  /// 支持的语言列表
  List<LanguageConfig> get supportedLanguages => _getSupportedLanguages();

  /// 获取支持的语言列表（避免无限递归）
  List<LanguageConfig> _getSupportedLanguages() {
    return [
      LanguageConfig(
        code: 'zh',
        name: 'Chinese',
        nativeName: '简体中文',
        flag: '🇨🇳',
      ),
      LanguageConfig(
        code: 'en',
        name: 'English',
        nativeName: 'English',
        flag: '🇺🇸',
      ),
    ];
  }

  /// 获取当前选择的语言配置
  LanguageConfig get selectedLanguageConfig {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == _selectedLanguage,
      orElse: () => supportedLanguages.first,
    );
  }

  /// 选择语言
  void selectLanguage(String languageCode) {
    if (_selectedLanguage != languageCode) {
      _selectedLanguage = languageCode;
      _showApplyButton = languageCode != _originalLanguage;
      notifyListeners();
    }
  }

  /// 应用语言更改
  Future<void> applyLanguageChange() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 保存语言设置到数据库
      await _dbHelper.saveSetting('language', _selectedLanguage);
      
      _languageChanged = true;
      _originalLanguage = _selectedLanguage;
      _showApplyButton = false;
      
      _isLoading = false;
      notifyListeners();
      
      // 延迟一下再重置状态，让用户看到成功提示
      Future.delayed(const Duration(seconds: 2), () {
        if (!_disposed) {
          _languageChanged = false;
          notifyListeners();
        }
      });
      
    } catch (e) {
      _errorMessage = '语言切换失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 检查语言是否被选中
  bool isLanguageSelected(String languageCode) {
    return _selectedLanguage == languageCode;
  }

  /// 获取语言显示名称
  String getLanguageDisplayName(String languageCode) {
    final config = supportedLanguages.firstWhere(
      (lang) => lang.code == languageCode,
      orElse: () => supportedLanguages.first,
    );
    return config.nativeName;
  }

  /// 获取语言英文名称
  String getLanguageEnglishName(String languageCode) {
    final config = supportedLanguages.firstWhere(
      (lang) => lang.code == languageCode,
      orElse: () => supportedLanguages.first,
    );
    return config.name;
  }

  /// 获取语言旗帜
  String getLanguageFlag(String languageCode) {
    final config = supportedLanguages.firstWhere(
      (lang) => lang.code == languageCode,
      orElse: () => supportedLanguages.first,
    );
    return config.flag;
  }

  /// 重置选择
  void resetSelection() {
    _selectedLanguage = _originalLanguage;
    _languageChanged = false;
    _showApplyButton = false;
    notifyListeners();
  }

  /// 获取语言切换提示消息
  String getLanguageChangeMessage() {
    final config = selectedLanguageConfig;
    return '${config.nativeName} ✓';
  }

  /// 检查是否有未保存的更改
  bool hasUnsavedChanges() {
    return _selectedLanguage != _originalLanguage;
  }

  /// 处理语言项点击
  void onLanguageItemTap(String languageCode) {
    selectLanguage(languageCode);
  }

  /// 获取语言项的描述文本
  String getLanguageDescription(String languageCode) {
    switch (languageCode) {
      case 'zh':
        return '简体中文界面';
      case 'en':
        return 'English interface';
      default:
        return '';
    }
  }

  /// 验证语言代码是否有效
  bool _isValidLanguage(String languageCode) {
    return supportedLanguages.any((lang) => lang.code == languageCode);
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

  /// 安全的notifyListeners，检查dispose状态
  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  /// 重写dispose方法
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
