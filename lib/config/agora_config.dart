/// Agora配置文件
class AgoraConfig {
  /// Agora App ID - 请替换为您的实际App ID
  static const String appId = "YOUR_AGORA_APP_ID";
  
  /// Agora App Certificate - 用于生成Token（可选）
  static const String appCertificate = "YOUR_AGORA_APP_CERTIFICATE";
  
  /// 默认频道名称
  static const String defaultChannelName = "rush_audio_chat";
  
  /// Token服务器URL（如果使用Token认证）
  static const String tokenServerUrl = "https://your-token-server.com";
  
  /// 音频配置
  static const int audioSampleRate = 48000;
  static const int audioBitrate = 48;
  static const int audioChannels = 1;
  
  /// 视频配置
  static const int videoWidth = 640;
  static const int videoHeight = 480;
  static const int videoFrameRate = 15;
  static const int videoBitrate = 400;
  
  /// 是否启用调试模式
  static const bool enableDebugMode = true;
  
  /// 日志级别
  static const int logLevel = 0x0001; // LOG_LEVEL_INFO
  
  /// 音频场景
  static const int audioScenario = 3; // AUDIO_SCENARIO_CHATROOM_ENTERTAINMENT
  
  /// 音频配置文件
  static const int audioProfile = 4; // AUDIO_PROFILE_DEFAULT
}



/// 连接状态
enum ConnectionState {
  /// 断开连接
  disconnected,
  /// 连接中
  connecting,
  /// 已连接
  connected,
  /// 重连中
  reconnecting,
  /// 连接失败
  failed,
}

/// 用户角色
enum UserRole {
  /// 主播
  broadcaster,
  /// 观众
  audience,
}

/// 音频状态
enum AudioState {
  /// 停止
  stopped,
  /// 开始
  starting,
  /// 本地静音
  localMuted,
  /// 本地未静音
  localUnmuted,
  /// 远端静音
  remoteMuted,
  /// 远端未静音
  remoteUnmuted,
  /// 本地音频失败
  localAudioFailed,
  /// 远端音频失败
  remoteAudioFailed,
}

/// 网络质量等级
enum NetworkQuality {
  /// 未知
  unknown,
  /// 优秀
  excellent,
  /// 良好
  good,
  /// 一般
  poor,
  /// 差
  bad,
  /// 很差
  vbad,
  /// 网络断开
  down,
  /// 不支持
  unsupported,
  /// 检测中
  detecting,
}
