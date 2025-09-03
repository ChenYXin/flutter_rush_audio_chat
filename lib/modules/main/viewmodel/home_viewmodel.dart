import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';

/// HomeFragment的ViewModel
class HomeViewModel with ChangeNotifier {
  /// 列表数据数量
  int _listCount = 10;
  int get listCount => _listCount;

  /// 刷新控制器
  late EasyRefreshController _refreshController;
  EasyRefreshController get refreshController => _refreshController;

  /// 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 错误状态
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 搜索关键词
  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  /// 构造函数
  HomeViewModel() {
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  /// 初始化数据
  void initData() {
    _listCount = 10;
    _errorMessage = null;
    notifyListeners();
  }

  /// 刷新数据
  Future<void> onRefresh() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 2));
      
      _listCount = 20;
      _refreshController.finishRefresh();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _refreshController.finishRefresh();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 加载更多数据
  Future<void> onLoad() async {
    try {
      _isLoading = true;
      notifyListeners();

      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 2));
      
      _listCount += 10;
      
      // 判断是否还有更多数据
      if (_listCount >= 50) {
        _refreshController.finishLoad(IndicatorResult.noMore);
      } else {
        _refreshController.finishLoad(IndicatorResult.success);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _refreshController.finishLoad(IndicatorResult.fail);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 搜索功能
  void onSearch(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  /// 清除搜索
  void clearSearch() {
    _searchKeyword = '';
    notifyListeners();
  }

  /// 获取用户标签颜色
  Color getUserTagColor(int index) {
    final colors = [
      Colors.blue,      // 新用户
      Colors.orange,    // 活跃用户
      Colors.purple,    // VIP用户
      Colors.green,     // 认证用户
      Colors.red,       // 管理员
      Colors.teal,      // 创作者
    ];
    return colors[index % colors.length];
  }

  /// 获取用户标签图标
  IconData getUserTagIcon(int index) {
    final icons = [
      Icons.new_releases,     // 新用户
      Icons.local_fire_department, // 活跃用户
      Icons.diamond,          // VIP用户
      Icons.verified,         // 认证用户
      Icons.admin_panel_settings, // 管理员
      Icons.create,           // 创作者
    ];
    return icons[index % icons.length];
  }

  /// 获取用户标签文本
  String getUserTagText(int index) {
    final tags = [
      "新用户",
      "活跃",
      "VIP",
      "认证",
      "管理员",
      "创作者",
    ];
    return tags[index % tags.length];
  }

  /// 获取用户等级
  int getUserLevel(int index) {
    return (index % 50) + 1;
  }

  /// 获取用户头像URL
  String getUserAvatarUrl(int index) {
    return "https://picsum.photos/70/70?random=${index + 10}";
  }

  /// 获取轮播图URL
  String getBannerImageUrl(int index) {
    return "https://picsum.photos/400/300?random=${index + 1}";
  }

  /// 获取用户昵称
  String getUserNickname(int index, String defaultNickname) {
    return "$defaultNickname ${index + 1}";
  }

  /// 处理搜索点击
  void onSearchTap() {
    // 导航到搜索页面的逻辑
  }

  /// 处理用户项点击
  void onUserItemTap(int index) {
    // 导航到用户资料页面的逻辑
  }

  /// 获取用户ID
  String getUserId(int index) {
    return 'user_${index + 1}';
  }

  /// 处理聊天按钮点击
  void onChatButtonTap(int index) {
    // 导航到聊天页面的逻辑
  }

  /// 处理轮播图点击
  void onBannerTap(int index) {
    // 导航到轮播图详情页面的逻辑
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

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
