import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';

/// MainPage的ViewModel，用于状态管理和业务逻辑
class MainPageViewModel with ChangeNotifier {
  /// 当前选中的标签页索引
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  /// 底部导航控制器
  CircularBottomNavigationController? _navigationController;
  CircularBottomNavigationController? get navigationController => _navigationController;

  /// 构造函数
  MainPageViewModel() {
    initialize();
  }

  /// 是否显示底部导航栏
  bool _showBottomNavigation = true;
  bool get showBottomNavigation => _showBottomNavigation;

  /// 未读消息数量
  int _unreadMessageCount = 0;
  int get unreadMessageCount => _unreadMessageCount;

  /// 标签页标题列表
  final List<String> _tabTitles = ['首页', '聊天', '个人中心'];
  List<String> get tabTitles => _tabTitles;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 上次按返回键的时间
  DateTime? _lastBackPressTime;

  /// 退出提示消息
  String? _exitMessage;
  String? get exitMessage => _exitMessage;

  /// 是否已被dispose
  bool _disposed = false;

  /// 初始化
  void initialize() {
    if (_navigationController == null) {
      _navigationController = CircularBottomNavigationController(_selectedIndex);
    }
  }

  /// 更新选中的标签页
  void updateSelectedTab(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      // 安全地更新导航控制器
      if (_navigationController != null) {
        _navigationController!.value = index;
      }
      notifyListeners();
    }
  }

  /// 更新底部导航栏可见性
  void updateBottomNavigationVisibility(bool visible) {
    if (_showBottomNavigation != visible) {
      _showBottomNavigation = visible;
      notifyListeners();
    }
  }

  /// 更新未读消息徽章
  void updateUnreadBadge(int count) {
    if (_unreadMessageCount != count) {
      _unreadMessageCount = count;
      notifyListeners();
    }
  }

  /// 处理标签页点击
  void onTabTap(int index) {
    updateSelectedTab(index);
  }

  /// 处理页面切换
  void onPageChanged(int index) {
    updateSelectedTab(index);
  }

  /// 获取标签页图标
  IconData getTabIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.chat;
      case 2:
        return Icons.person;
      default:
        return Icons.home;
    }
  }

  /// 获取当前页面标题
  String getCurrentPageTitle() {
    if (_selectedIndex >= 0 && _selectedIndex < _tabTitles.length) {
      return _tabTitles[_selectedIndex];
    }
    return _tabTitles[0];
  }

  /// 是否是首页
  bool get isHomePage => _selectedIndex == 0;

  /// 是否是聊天页
  bool get isChatPage => _selectedIndex == 1;

  /// 是否是个人中心页
  bool get isProfilePage => _selectedIndex == 2;

  /// 重置到首页
  void resetToHome() {
    updateSelectedTab(0);
  }

  /// 跳转到聊天页
  void goToChatPage() {
    updateSelectedTab(1);
  }

  /// 跳转到个人中心页
  void goToProfilePage() {
    updateSelectedTab(2);
  }

  /// 增加未读消息数量
  void incrementUnreadCount() {
    _unreadMessageCount++;
    notifyListeners();
  }

  /// 清除未读消息数量
  void clearUnreadCount() {
    _unreadMessageCount = 0;
    notifyListeners();
  }

  /// 处理返回按键
  bool onWillPop() {
    if (_selectedIndex != 0) {
      // 如果不在首页，返回首页
      updateSelectedTab(0);
      return false;
    }

    // 在首页时，实现双击退出
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      // 第一次按返回键或距离上次按键超过2秒
      _lastBackPressTime = now;
      _exitMessage = '再按一次退出应用';
      notifyListeners();

      // 2秒后清除提示消息
      Future.delayed(const Duration(seconds: 2), () {
        if (!_disposed) {
          _exitMessage = null;
          notifyListeners();
        }
      });

      return false; // 不退出应用
    } else {
      // 2秒内第二次按返回键，退出应用
      return true;
    }
  }

  /// 刷新当前页面
  void refreshCurrentPage() {
    // 可以根据当前页面执行相应的刷新操作
    notifyListeners();
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

  @override
  void dispose() {
    _disposed = true;
    _navigationController?.dispose();
    super.dispose();
  }
}
