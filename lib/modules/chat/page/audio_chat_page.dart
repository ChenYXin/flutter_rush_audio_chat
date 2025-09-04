import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commom/my_color.dart';
import '../../../widget/cache_image.dart';
import '../viewmodel/audio_chat_viewmodel.dart';

/// 音频聊天页面
class AudioChatPage extends StatefulWidget {
  final String channelName;
  final String? userName;

  const AudioChatPage({
    super.key,
    required this.channelName,
    this.userName,
  });

  @override
  State<AudioChatPage> createState() => _AudioChatPageState();
}

class _AudioChatPageState extends State<AudioChatPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AudioChatViewModel()..joinChannel(widget.channelName),
      child: Consumer<AudioChatViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A1A1A),
            body: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context, viewModel),
                  Expanded(
                    child: _buildBody(context, viewModel),
                  ),
                  _buildControlPanel(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildAppBar(BuildContext context, AudioChatViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              await viewModel.leaveChannel();
              if (mounted) Navigator.pop(context);
            },
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  viewModel.channelName.isNotEmpty 
                      ? viewModel.channelName 
                      : '音频聊天',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (viewModel.isJoined) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${viewModel.onlineUserCount}人在线 · ${viewModel.formattedDuration}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showMoreOptions(context, viewModel),
          ),
        ],
      ),
    );
  }

  /// 构建主体内容
  Widget _buildBody(BuildContext context, AudioChatViewModel viewModel) {
    if (viewModel.isConnecting) {
      return _buildConnectingView();
    }

    if (viewModel.errorMessage != null) {
      return _buildErrorView(viewModel);
    }

    if (!viewModel.isJoined) {
      return _buildWaitingView();
    }

    return _buildChatView(viewModel);
  }

  /// 构建连接中视图
  Widget _buildConnectingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            '正在连接...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// 构建错误视图
  Widget _buildErrorView(AudioChatViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.errorMessage!,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              viewModel.clearError();
              viewModel.joinChannel(widget.channelName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.watch<MyColor>().colorPrimary,
            ),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 构建等待视图
  Widget _buildWaitingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mic_off,
            color: Colors.white54,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            '等待加入聊天室...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// 构建聊天视图
  Widget _buildChatView(AudioChatViewModel viewModel) {
    return Column(
      children: [
        // 本地用户
        Expanded(
          flex: 2,
          child: _buildLocalUser(viewModel),
        ),
        
        // 远端用户列表
        if (viewModel.remoteUsers.isNotEmpty)
          Expanded(
            flex: 3,
            child: _buildRemoteUsers(viewModel),
          ),
      ],
    );
  }

  /// 构建本地用户
  Widget _buildLocalUser(AudioChatViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: viewModel.isMuted ? 1.0 : _pulseAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        context.watch<MyColor>().colorPrimary,
                        context.watch<MyColor>().colorPrimary.withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.watch<MyColor>().colorPrimary.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: SvCacheImage(
                          imageUrl: 'https://via.placeholder.com/120',
                          width: 100,
                          height: 100,
                          radius: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (viewModel.isMuted)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mic_off,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            widget.userName ?? '我',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            viewModel.isMuted ? '已静音' : '正在说话',
            style: TextStyle(
              color: viewModel.isMuted ? Colors.red : Colors.green,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建远端用户列表
  Widget _buildRemoteUsers(AudioChatViewModel viewModel) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: viewModel.remoteUsers.length,
      itemBuilder: (context, index) {
        final user = viewModel.remoteUsers[index];
        return _buildRemoteUserItem(user);
      },
    );
  }

  /// 构建远端用户项
  Widget _buildRemoteUserItem(ChatUser user) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: user.isOnline ? Colors.green : Colors.grey,
              width: 3,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: SvCacheImage(
                  imageUrl: user.avatar ?? 'https://via.placeholder.com/80',
                  width: 70,
                  height: 70,
                  radius: 35,
                  fit: BoxFit.cover,
                ),
              ),
              if (user.isMuted)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic_off,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          user.isMuted ? '已静音' : '在线',
          style: TextStyle(
            color: user.isMuted ? Colors.red : Colors.green,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// 构建控制面板
  Widget _buildControlPanel(BuildContext context, AudioChatViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 静音按钮
          _buildControlButton(
            icon: viewModel.isMuted ? Icons.mic_off : Icons.mic,
            color: viewModel.isMuted ? Colors.red : Colors.white,
            backgroundColor: viewModel.isMuted ? Colors.red.withOpacity(0.2) : Colors.white.withOpacity(0.2),
            onPressed: viewModel.toggleMute,
          ),
          
          // 扬声器按钮
          _buildControlButton(
            icon: viewModel.isSpeakerEnabled ? Icons.volume_up : Icons.volume_off,
            color: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.2),
            onPressed: viewModel.toggleSpeaker,
          ),
          
          // 挂断按钮
          _buildControlButton(
            icon: Icons.call_end,
            color: Colors.white,
            backgroundColor: Colors.red,
            onPressed: () async {
              await viewModel.leaveChannel();
              if (mounted) Navigator.pop(context);
            },
            size: 64,
          ),
        ],
      ),
    );
  }

  /// 构建控制按钮
  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onPressed,
    double size = 56,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: size * 0.4,
        ),
      ),
    );
  }

  /// 显示更多选项
  void _showMoreOptions(BuildContext context, AudioChatViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text('房间信息', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showRoomInfo(context, viewModel);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('音频设置', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // TODO: 实现音频设置
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 显示房间信息
  void _showRoomInfo(BuildContext context, AudioChatViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('房间信息', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('房间名称: ${viewModel.channelName}', style: const TextStyle(color: Colors.white)),
            Text('在线人数: ${viewModel.onlineUserCount}', style: const TextStyle(color: Colors.white)),
            Text('通话时长: ${viewModel.formattedDuration}', style: const TextStyle(color: Colors.white)),
            if (viewModel.localUid != null)
              Text('用户ID: ${viewModel.localUid}', style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
