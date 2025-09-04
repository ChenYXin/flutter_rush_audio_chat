import 'dart:async';
import 'package:flutter/material.dart';
import '../../../services/agora_service.dart';
import '../../../config/agora_config.dart';

/// 音频聊天页面ViewModel
class AudioChatViewModel with ChangeNotifier {
  /// Agora服务实例
  final AgoraService _agoraService = AgoraService.instance;

  /// 当前频道名称
  String _channelName = '';
  String get channelName => _channelName;

  /// 当前用户ID
  int? _localUid;
  int? get localUid => _localUid;

  /// 远端用户列表
  List<ChatUser> _remoteUsers = [];
  List<ChatUser> get remoteUsers => _remoteUsers;

  /// 是否已加入频道
  bool _isJoined = false;
  bool get isJoined => _isJoined;

  /// 是否静音
  bool _isMuted = false;
  bool get isMuted => _isMuted;

  /// 是否启用扬声器
  bool _isSpeakerEnabled = true;
  bool get isSpeakerEnabled => _isSpeakerEnabled;

  /// 是否正在连接
  bool _isConnecting = false;
  bool get isConnecting => _isConnecting;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 通话时长
  Duration _callDuration = Duration.zero;
  Duration get callDuration => _callDuration;

  /// 计时器
  Timer? _timer;

  /// 事件订阅
  StreamSubscription<AgoraEvent>? _eventSubscription;

  /// 是否已dispose
  bool _disposed = false;

  /// 构造函数
  AudioChatViewModel() {
    _initializeAgora();
    _subscribeToAgoraEvents();
  }

  /// 初始化Agora
  Future<void> _initializeAgora() async {
    try {
      final success = await _agoraService.initialize();
      if (!success) {
        _errorMessage = '音频引擎初始化失败';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = '初始化失败: ${e.toString()}';
      notifyListeners();
    }
  }

  /// 订阅Agora事件
  void _subscribeToAgoraEvents() {
    _eventSubscription = _agoraService.eventStream.listen((event) {
      if (_disposed) return;

      switch (event.type) {
        case AgoraEventType.joinChannelSuccess:
          _handleJoinChannelSuccess(event);
          break;
        case AgoraEventType.userJoined:
          _handleUserJoined(event);
          break;
        case AgoraEventType.userOffline:
          _handleUserOffline(event);
          break;
        case AgoraEventType.leaveChannel:
          _handleLeaveChannel(event);
          break;
        case AgoraEventType.error:
          _handleError(event);
          break;
      }
    });
  }

  /// 处理加入频道成功
  void _handleJoinChannelSuccess(AgoraEvent event) {
    _isJoined = true;
    _isConnecting = false;
    _localUid = event.uid;
    _errorMessage = null;
    _startTimer();
    notifyListeners();
  }

  /// 处理用户加入
  void _handleUserJoined(AgoraEvent event) {
    if (event.uid != null) {
      final user = ChatUser(
        uid: event.uid!,
        name: '用户${event.uid}',
        isOnline: true,
        isMuted: false,
      );
      _remoteUsers.add(user);
      notifyListeners();
    }
  }

  /// 处理用户离开
  void _handleUserOffline(AgoraEvent event) {
    if (event.uid != null) {
      _remoteUsers.removeWhere((user) => user.uid == event.uid);
      notifyListeners();
    }
  }

  /// 处理离开频道
  void _handleLeaveChannel(AgoraEvent event) {
    _isJoined = false;
    _isConnecting = false;
    _localUid = null;
    _remoteUsers.clear();
    _stopTimer();
    notifyListeners();
  }

  /// 处理错误
  void _handleError(AgoraEvent event) {
    final data = event.data as Map<String, dynamic>;
    _errorMessage = '错误: ${data['message']}';
    _isConnecting = false;
    notifyListeners();
  }

  /// 加入频道
  Future<void> joinChannel(String channelName, {String? userName}) async {
    if (_isConnecting || _isJoined) return;

    try {
      _isConnecting = true;
      _channelName = channelName;
      _errorMessage = null;
      notifyListeners();

      final success = await _agoraService.joinChannel(channelName);
      if (!success) {
        _isConnecting = false;
        _errorMessage = '加入频道失败';
        notifyListeners();
      }
    } catch (e) {
      _isConnecting = false;
      _errorMessage = '加入频道失败: ${e.toString()}';
      notifyListeners();
    }
  }

  /// 离开频道
  Future<void> leaveChannel() async {
    try {
      await _agoraService.leaveChannel();
    } catch (e) {
      _errorMessage = '离开频道失败: ${e.toString()}';
      notifyListeners();
    }
  }

  /// 切换静音状态
  Future<void> toggleMute() async {
    try {
      await _agoraService.toggleMute();
      _isMuted = _agoraService.isMuted;
      notifyListeners();
    } catch (e) {
      _errorMessage = '切换静音失败: ${e.toString()}';
      notifyListeners();
    }
  }

  /// 切换扬声器
  Future<void> toggleSpeaker() async {
    try {
      await _agoraService.toggleSpeaker();
      _isSpeakerEnabled = _agoraService.isSpeakerEnabled;
      notifyListeners();
    } catch (e) {
      _errorMessage = '切换扬声器失败: ${e.toString()}';
      notifyListeners();
    }
  }

  /// 开始计时
  void _startTimer() {
    _callDuration = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_disposed) {
        _callDuration = Duration(seconds: _callDuration.inSeconds + 1);
        notifyListeners();
      }
    });
  }

  /// 停止计时
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _callDuration = Duration.zero;
  }

  /// 格式化通话时长
  String get formattedDuration {
    final hours = _callDuration.inHours;
    final minutes = _callDuration.inMinutes % 60;
    final seconds = _callDuration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// 获取在线用户数量
  int get onlineUserCount => _remoteUsers.length + (_isJoined ? 1 : 0);

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
    _eventSubscription?.cancel();
    _stopTimer();
    super.dispose();
  }
}

/// 聊天用户数据模型
class ChatUser {
  final int uid;
  final String name;
  final bool isOnline;
  final bool isMuted;
  final String? avatar;

  ChatUser({
    required this.uid,
    required this.name,
    required this.isOnline,
    required this.isMuted,
    this.avatar,
  });

  ChatUser copyWith({
    int? uid,
    String? name,
    bool? isOnline,
    bool? isMuted,
    String? avatar,
  }) {
    return ChatUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      isOnline: isOnline ?? this.isOnline,
      isMuted: isMuted ?? this.isMuted,
      avatar: avatar ?? this.avatar,
    );
  }
}
