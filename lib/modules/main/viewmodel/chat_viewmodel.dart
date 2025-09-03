import 'package:flutter/material.dart';

/// 聊天页面的ViewModel
class ChatViewModel with ChangeNotifier {
  /// 聊天列表数据
  List<ChatItem> _chatList = [];
  List<ChatItem> get chatList => _chatList;
  
  /// 搜索关键词
  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;
  
  /// 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 构造函数
  ChatViewModel() {
    _initializeChatData();
  }

  /// 获取过滤后的聊天列表
  List<ChatItem> get filteredChatList {
    if (_searchKeyword.isEmpty) {
      return _chatList;
    }
    return _chatList.where((chat) => 
      chat.name.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
      chat.lastMessage.toLowerCase().contains(_searchKeyword.toLowerCase())
    ).toList();
  }

  /// 初始化聊天数据
  void _initializeChatData() {
    _chatList = [
      ChatItem(
        id: '1',
        name: '张三',
        avatar: 'https://picsum.photos/60/60?random=1',
        lastMessage: '你好，最近怎么样？',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 2,
        isOnline: true,
      ),
      ChatItem(
        id: '2',
        name: '李四',
        avatar: 'https://picsum.photos/60/60?random=2',
        lastMessage: '明天的会议记得参加',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
        isOnline: false,
      ),
      ChatItem(
        id: '3',
        name: '王五',
        avatar: 'https://picsum.photos/60/60?random=3',
        lastMessage: '项目进展如何？',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 1,
        isOnline: true,
      ),
      ChatItem(
        id: '4',
        name: '赵六',
        avatar: 'https://picsum.photos/60/60?random=4',
        lastMessage: '周末一起吃饭吧',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: false,
      ),
      ChatItem(
        id: '5',
        name: '钱七',
        avatar: 'https://picsum.photos/60/60?random=5',
        lastMessage: '文件已经发送给你了',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        unreadCount: 3,
        isOnline: true,
      ),
    ];
    notifyListeners();
  }

  /// 搜索聊天
  void searchChats(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  /// 清除搜索
  void clearSearch() {
    _searchKeyword = '';
    notifyListeners();
  }

  /// 标记消息为已读
  void markAsRead(String chatId) {
    final index = _chatList.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      _chatList[index] = _chatList[index].copyWith(unreadCount: 0);
      notifyListeners();
    }
  }

  /// 删除聊天
  void deleteChat(String chatId) {
    _chatList.removeWhere((chat) => chat.id == chatId);
    notifyListeners();
  }

  /// 刷新聊天列表
  Future<void> refreshChats() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));
      
      _initializeChatData();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 处理聊天项点击
  void onChatItemTap(ChatItem chat) {
    // 标记为已读
    markAsRead(chat.id);
  }

  /// 获取未读消息总数
  int getTotalUnreadCount() {
    return _chatList.fold(0, (sum, chat) => sum + chat.unreadCount);
  }

  /// 获取格式化的时间显示
  String getFormattedTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${timestamp.month}/${timestamp.day}';
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

/// 聊天项数据模型
class ChatItem {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isOnline;

  ChatItem({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isOnline,
  });

  ChatItem copyWith({
    String? id,
    String? name,
    String? avatar,
    String? lastMessage,
    DateTime? timestamp,
    int? unreadCount,
    bool? isOnline,
  }) {
    return ChatItem(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
