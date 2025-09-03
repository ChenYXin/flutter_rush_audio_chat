import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';

/// 搜索页面的ViewModel
class SearchViewModel with ChangeNotifier {
  /// 搜索关键词
  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  /// 搜索结果列表
  List<SearchUserItem> _searchResults = [];
  List<SearchUserItem> get searchResults => _searchResults;

  /// 搜索历史
  List<String> _searchHistory = [];
  List<String> get searchHistory => _searchHistory;

  /// 热门搜索
  final List<String> _hotSearches = [
    '美女主播',
    '游戏达人',
    '音乐才子',
    '舞蹈女神',
    '搞笑博主',
    '知识分享',
    '生活记录',
    '旅行达人',
  ];
  List<String> get hotSearches => _hotSearches;

  /// 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 是否显示搜索结果
  bool _showResults = false;
  bool get showResults => _showResults;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 数据库助手
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// 构造函数
  SearchViewModel() {
    _loadSearchHistory();
  }

  /// 加载搜索历史
  Future<void> _loadSearchHistory() async {
    try {
      _searchHistory = await _dbHelper.getSearchHistory();
      notifyListeners();
    } catch (e) {
      // 加载失败时使用空列表
      _searchHistory = [];
    }
  }

  /// 执行搜索
  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) {
      _showResults = false;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _searchKeyword = keyword.trim();
      _errorMessage = null;
      notifyListeners();

      // 模拟网络搜索请求
      await Future.delayed(const Duration(seconds: 1));

      // 模拟搜索结果
      _searchResults = _generateSearchResults(keyword);
      _showResults = true;

      // 添加到搜索历史
      _addToHistory(keyword);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = '搜索失败: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 生成模拟搜索结果
  List<SearchUserItem> _generateSearchResults(String keyword) {
    final results = <SearchUserItem>[];
    
    for (int i = 0; i < 20; i++) {
      results.add(SearchUserItem(
        id: 'user_${i + 1}',
        nickname: '$keyword用户${i + 1}',
        avatar: 'https://picsum.photos/60/60?random=${i + 100}',
        age: 18 + (i % 30),
        gender: i % 2 == 0 ? '女' : '男',
        location: _getRandomLocation(),
        tags: _getRandomTags(),
        isOnline: i % 3 == 0,
        level: (i % 50) + 1,
        fansCount: (i + 1) * 100 + (i * 50),
      ));
    }
    
    return results;
  }

  /// 获取随机位置
  String _getRandomLocation() {
    final locations = ['北京', '上海', '广州', '深圳', '杭州', '成都', '重庆', '西安'];
    return locations[DateTime.now().millisecond % locations.length];
  }

  /// 获取随机标签
  List<String> _getRandomTags() {
    final allTags = ['颜值', '才艺', '游戏', '音乐', '舞蹈', '搞笑', '知识', '生活'];
    final tagCount = 1 + (DateTime.now().millisecond % 3);
    final tags = <String>[];
    
    for (int i = 0; i < tagCount; i++) {
      final tag = allTags[(DateTime.now().millisecond + i) % allTags.length];
      if (!tags.contains(tag)) {
        tags.add(tag);
      }
    }
    
    return tags;
  }

  /// 添加到搜索历史
  Future<void> _addToHistory(String keyword) async {
    try {
      await _dbHelper.saveSearchHistory(keyword);
      // 重新加载搜索历史
      await _loadSearchHistory();
    } catch (e) {
      // 保存失败时的处理
      print('保存搜索历史失败: $e');
    }
  }

  /// 清除搜索历史
  Future<void> clearSearchHistory() async {
    try {
      await _dbHelper.clearSearchHistory();
      _searchHistory.clear();
      notifyListeners();
    } catch (e) {
      showError('清除搜索历史失败: ${e.toString()}');
    }
  }

  /// 删除单个历史记录
  Future<void> removeHistoryItem(String keyword) async {
    try {
      await _dbHelper.deleteSearchHistoryItem(keyword);
      _searchHistory.remove(keyword);
      notifyListeners();
    } catch (e) {
      showError('删除搜索历史失败: ${e.toString()}');
    }
  }

  /// 点击热门搜索
  void onHotSearchTap(String keyword) {
    search(keyword);
  }

  /// 点击历史搜索
  void onHistorySearchTap(String keyword) {
    search(keyword);
  }

  /// 清除搜索结果
  void clearResults() {
    _searchResults.clear();
    _showResults = false;
    _searchKeyword = '';
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
}

/// 搜索用户项数据模型
class SearchUserItem {
  final String id;
  final String nickname;
  final String avatar;
  final int age;
  final String gender;
  final String location;
  final List<String> tags;
  final bool isOnline;
  final int level;
  final int fansCount;

  SearchUserItem({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.age,
    required this.gender,
    required this.location,
    required this.tags,
    required this.isOnline,
    required this.level,
    required this.fansCount,
  });
}
