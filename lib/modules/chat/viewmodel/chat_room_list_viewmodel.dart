import 'package:flutter/material.dart';

/// 聊天室列表ViewModel
class ChatRoomListViewModel with ChangeNotifier {
  /// 聊天室列表
  List<ChatRoom> _chatRooms = [];
  List<ChatRoom> get chatRooms => _chatRooms;

  /// 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 是否已dispose
  bool _disposed = false;

  /// 构造函数
  ChatRoomListViewModel() {
    _loadChatRooms();
  }

  /// 加载聊天室列表
  Future<void> _loadChatRooms() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));

      // 模拟聊天室数据
      _chatRooms = _generateMockChatRooms();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = '加载聊天室失败: ${e.toString()}';
      notifyListeners();
    }
  }

  /// 刷新聊天室列表
  Future<void> refreshChatRooms() async {
    await _loadChatRooms();
  }

  /// 生成模拟聊天室数据
  List<ChatRoom> _generateMockChatRooms() {
    return [
      ChatRoom(
        id: 'room_1',
        name: '音乐爱好者',
        description: '分享和讨论各种音乐',
        memberCount: 15,
        isOnline: true,
        lastActiveTime: DateTime.now().subtract(const Duration(minutes: 5)),
        avatar: 'https://via.placeholder.com/60',
      ),
      ChatRoom(
        id: 'room_2',
        name: '游戏交流',
        description: '游戏攻略和心得分享',
        memberCount: 23,
        isOnline: true,
        lastActiveTime: DateTime.now().subtract(const Duration(minutes: 12)),
        avatar: 'https://via.placeholder.com/60',
      ),
      ChatRoom(
        id: 'room_3',
        name: '技术讨论',
        description: '编程技术交流',
        memberCount: 8,
        isOnline: false,
        lastActiveTime: DateTime.now().subtract(const Duration(hours: 2)),
        avatar: 'https://via.placeholder.com/60',
      ),
      ChatRoom(
        id: 'room_4',
        name: '美食分享',
        description: '分享美食制作和推荐',
        memberCount: 31,
        isOnline: true,
        lastActiveTime: DateTime.now().subtract(const Duration(minutes: 1)),
        avatar: 'https://via.placeholder.com/60',
      ),
      ChatRoom(
        id: 'room_5',
        name: '旅行故事',
        description: '分享旅行经历和攻略',
        memberCount: 12,
        isOnline: false,
        lastActiveTime: DateTime.now().subtract(const Duration(hours: 5)),
        avatar: 'https://via.placeholder.com/60',
      ),
      ChatRoom(
        id: 'room_6',
        name: '读书会',
        description: '读书心得和推荐',
        memberCount: 19,
        isOnline: true,
        lastActiveTime: DateTime.now().subtract(const Duration(minutes: 30)),
        avatar: 'https://via.placeholder.com/60',
      ),
    ];
  }

  /// 创建聊天室
  Future<ChatRoom?> createChatRoom(String name, String? description) async {
    try {
      _isLoading = true;
      notifyListeners();

      // 模拟创建聊天室的网络请求
      await Future.delayed(const Duration(seconds: 1));

      final newRoom = ChatRoom(
        id: 'room_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description,
        memberCount: 1,
        isOnline: true,
        lastActiveTime: DateTime.now(),
      );

      _chatRooms.insert(0, newRoom);
      _isLoading = false;
      notifyListeners();

      return newRoom;
    } catch (e) {
      _isLoading = false;
      _errorMessage = '创建聊天室失败: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  /// 加入聊天室
  Future<bool> joinChatRoom(String roomId) async {
    try {
      // 模拟加入聊天室的网络请求
      await Future.delayed(const Duration(milliseconds: 500));

      // 更新聊天室成员数量
      final roomIndex = _chatRooms.indexWhere((room) => room.id == roomId);
      if (roomIndex != -1) {
        _chatRooms[roomIndex] = _chatRooms[roomIndex].copyWith(
          memberCount: _chatRooms[roomIndex].memberCount + 1,
          lastActiveTime: DateTime.now(),
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = '加入聊天室失败: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// 离开聊天室
  Future<bool> leaveChatRoom(String roomId) async {
    try {
      // 模拟离开聊天室的网络请求
      await Future.delayed(const Duration(milliseconds: 500));

      // 更新聊天室成员数量
      final roomIndex = _chatRooms.indexWhere((room) => room.id == roomId);
      if (roomIndex != -1 && _chatRooms[roomIndex].memberCount > 0) {
        _chatRooms[roomIndex] = _chatRooms[roomIndex].copyWith(
          memberCount: _chatRooms[roomIndex].memberCount - 1,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = '离开聊天室失败: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// 搜索聊天室
  List<ChatRoom> searchChatRooms(String query) {
    if (query.isEmpty) return _chatRooms;

    return _chatRooms.where((room) {
      return room.name.toLowerCase().contains(query.toLowerCase()) ||
          (room.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  /// 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// 安全的notifyListeners
  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// 聊天室数据模型
class ChatRoom {
  final String id;
  final String name;
  final String? description;
  final int memberCount;
  final bool isOnline;
  final DateTime lastActiveTime;
  final String? avatar;
  final List<String>? tags;

  ChatRoom({
    required this.id,
    required this.name,
    this.description,
    required this.memberCount,
    required this.isOnline,
    required this.lastActiveTime,
    this.avatar,
    this.tags,
  });

  ChatRoom copyWith({
    String? id,
    String? name,
    String? description,
    int? memberCount,
    bool? isOnline,
    DateTime? lastActiveTime,
    String? avatar,
    List<String>? tags,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      memberCount: memberCount ?? this.memberCount,
      isOnline: isOnline ?? this.isOnline,
      lastActiveTime: lastActiveTime ?? this.lastActiveTime,
      avatar: avatar ?? this.avatar,
      tags: tags ?? this.tags,
    );
  }
}
