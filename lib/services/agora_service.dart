import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../config/agora_config.dart';

/// Agora RTC服务管理类
class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  static AgoraService get instance => _instance;
  
  AgoraService._internal();

  /// RTC引擎实例
  RtcEngine? _engine;
  RtcEngine? get engine => _engine;

  /// 当前频道名称
  String? _currentChannel;
  String? get currentChannel => _currentChannel;

  /// 当前用户ID
  int? _currentUid;
  int? get currentUid => _currentUid;

  /// 是否已加入频道
  bool _isJoined = false;
  bool get isJoined => _isJoined;

  /// 是否静音
  bool _isMuted = false;
  bool get isMuted => _isMuted;

  /// 是否启用扬声器
  bool _isSpeakerEnabled = true;
  bool get isSpeakerEnabled => _isSpeakerEnabled;

  /// 远端用户列表
  final Set<int> _remoteUsers = <int>{};
  Set<int> get remoteUsers => Set.unmodifiable(_remoteUsers);

  /// 事件流控制器
  final StreamController<AgoraEvent> _eventController = StreamController<AgoraEvent>.broadcast();
  Stream<AgoraEvent> get eventStream => _eventController.stream;

  /// 初始化Agora引擎
  Future<bool> initialize() async {
    try {
      // 检查App ID
      if (AgoraConfig.appId.isEmpty || AgoraConfig.appId == "YOUR_AGORA_APP_ID") {
        log('错误: 请在AgoraConfig中设置正确的App ID');
        return false;
      }

      // 请求权限
      if (!await _requestPermissions()) {
        log('权限请求失败');
        return false;
      }

      // 创建RTC引擎
      _engine = createAgoraRtcEngine();
      
      // 初始化引擎
      await _engine!.initialize(RtcEngineContext(
        appId: AgoraConfig.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      // 启用音频
      await _engine!.enableAudio();
      
      // 设置音频配置
      await _engine!.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioGameStreaming,
      );

      // 注册事件处理器
      _registerEventHandlers();

      log('Agora引擎初始化成功');
      return true;
    } catch (e) {
      log('Agora引擎初始化失败: $e');
      return false;
    }
  }

  /// 请求必要权限
  Future<bool> _requestPermissions() async {
    final permissions = [
      Permission.microphone,
      Permission.camera,
    ];

    Map<Permission, PermissionStatus> statuses = await permissions.request();
    
    return statuses[Permission.microphone] == PermissionStatus.granted;
  }

  /// 注册事件处理器
  void _registerEventHandlers() {
    if (_engine == null) return;

    _engine!.registerEventHandler(RtcEngineEventHandler(
      // 加入频道成功
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        log('本地用户 ${connection.localUid} 加入频道 ${connection.channelId}');
        _isJoined = true;
        _currentUid = connection.localUid;
        _eventController.add(AgoraEvent(
          type: AgoraEventType.joinChannelSuccess,
          uid: connection.localUid,
          channelId: connection.channelId,
        ));
      },

      // 用户加入频道
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        log('远端用户 $remoteUid 加入频道');
        _remoteUsers.add(remoteUid);
        _eventController.add(AgoraEvent(
          type: AgoraEventType.userJoined,
          uid: remoteUid,
          channelId: connection.channelId,
        ));
      },

      // 用户离开频道
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        log('远端用户 $remoteUid 离开频道，原因: $reason');
        _remoteUsers.remove(remoteUid);
        _eventController.add(AgoraEvent(
          type: AgoraEventType.userOffline,
          uid: remoteUid,
          channelId: connection.channelId,
          data: reason,
        ));
      },

      // 离开频道
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log('离开频道 ${connection.channelId}');
        _isJoined = false;
        _currentChannel = null;
        _currentUid = null;
        _remoteUsers.clear();
        _eventController.add(AgoraEvent(
          type: AgoraEventType.leaveChannel,
          channelId: connection.channelId,
          data: stats,
        ));
      },

      // 错误回调
      onError: (ErrorCodeType err, String msg) {
        log('Agora错误: $err, 消息: $msg');
        _eventController.add(AgoraEvent(
          type: AgoraEventType.error,
          data: {'error': err, 'message': msg},
        ));
      },
    ));
  }

  /// 加入频道
  Future<bool> joinChannel(String channelName, {String? token, int uid = 0}) async {
    if (_engine == null) {
      log('引擎未初始化');
      return false;
    }

    try {
      // 启用屏幕常亮
      await WakelockPlus.enable();

      // 加入频道
      await _engine!.joinChannel(
        token: token ?? "",
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          autoSubscribeAudio: true,
          publishMicrophoneTrack: true,
        ),
      );

      _currentChannel = channelName;
      log('正在加入频道: $channelName');
      return true;
    } catch (e) {
      log('加入频道失败: $e');
      return false;
    }
  }

  /// 离开频道
  Future<void> leaveChannel() async {
    if (_engine == null) return;

    try {
      await _engine!.leaveChannel();
      
      // 禁用屏幕常亮
      await WakelockPlus.disable();
      
      log('离开频道');
    } catch (e) {
      log('离开频道失败: $e');
    }
  }

  /// 切换静音状态
  Future<void> toggleMute() async {
    if (_engine == null) return;

    try {
      _isMuted = !_isMuted;
      await _engine!.muteLocalAudioStream(_isMuted);
      log('${_isMuted ? "静音" : "取消静音"}');
    } catch (e) {
      log('切换静音失败: $e');
    }
  }

  /// 切换扬声器
  Future<void> toggleSpeaker() async {
    if (_engine == null) return;

    try {
      _isSpeakerEnabled = !_isSpeakerEnabled;
      await _engine!.setEnableSpeakerphone(_isSpeakerEnabled);
      log('${_isSpeakerEnabled ? "启用" : "禁用"}扬声器');
    } catch (e) {
      log('切换扬声器失败: $e');
    }
  }

  /// 销毁引擎
  Future<void> dispose() async {
    try {
      await leaveChannel();
      await _engine?.release();
      await WakelockPlus.disable();
      _engine = null;
      _eventController.close();
      log('Agora引擎已销毁');
    } catch (e) {
      log('销毁引擎失败: $e');
    }
  }
}

/// Agora事件数据类
class AgoraEvent {
  final AgoraEventType type;
  final int? uid;
  final String? channelId;
  final dynamic data;

  AgoraEvent({
    required this.type,
    this.uid,
    this.channelId,
    this.data,
  });
}

/// Agora事件类型
enum AgoraEventType {
  joinChannelSuccess,
  userJoined,
  userOffline,
  leaveChannel,
  error,
}
