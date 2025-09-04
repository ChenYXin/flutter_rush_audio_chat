import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commom/my_color.dart';
import '../../../generated/l10n.dart';
import '../../../router/fluro_navigator.dart';
import '../../../modules/main/main_router.dart';
import '../../../widget/cache_image.dart';
import '../viewmodel/chat_room_list_viewmodel.dart';

/// 聊天室列表页面
class ChatRoomListPage extends StatefulWidget {
  const ChatRoomListPage({super.key});

  @override
  State<ChatRoomListPage> createState() => _ChatRoomListPageState();
}

class _ChatRoomListPageState extends State<ChatRoomListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatRoomListViewModel(),
      child: Consumer<ChatRoomListViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: _buildAppBar(context),
            body: _buildBody(context, viewModel),
            floatingActionButton: _buildFloatingActionButton(context),
          );
        },
      ),
    );
  }

  /// 构建AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).title_chat),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: 实现搜索聊天室功能
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showMoreOptions(context),
        ),
      ],
    );
  }

  /// 构建主体内容
  Widget _buildBody(BuildContext context, ChatRoomListViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.chatRooms.isEmpty) {
      return _buildEmptyView(context);
    }

    return RefreshIndicator(
      onRefresh: viewModel.refreshChatRooms,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.chatRooms.length,
        itemBuilder: (context, index) {
          final room = viewModel.chatRooms[index];
          return _buildChatRoomItem(context, room);
        },
      ),
    );
  }

  /// 构建空状态视图
  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无聊天室',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '创建或加入聊天室开始聊天',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateRoomDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('创建聊天室'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.watch<MyColor>().colorPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建聊天室项
  Widget _buildChatRoomItem(BuildContext context, ChatRoom room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _joinChatRoom(context, room),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 聊天室头像
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        context.watch<MyColor>().colorPrimary,
                        context.watch<MyColor>().colorPrimary.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: room.avatar != null
                      ? SvCacheImage(
                          imageUrl: room.avatar!,
                          width: 60,
                          height: 60,
                          radius: 12,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.chat,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
                const SizedBox(width: 16),
                
                // 聊天室信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              room.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (room.isOnline)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                '在线',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        room.description ?? '欢迎加入聊天室',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${room.memberCount}人',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(room.lastActiveTime),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 加入按钮
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.watch<MyColor>().colorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '加入',
                    style: TextStyle(
                      color: context.watch<MyColor>().colorPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建浮动操作按钮
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateRoomDialog(context),
      backgroundColor: context.watch<MyColor>().colorPrimary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  /// 加入聊天室
  void _joinChatRoom(BuildContext context, ChatRoom room) {
    NavigatorUtils.push(
      context,
      '${MainRouter.audioChatPage}?channelName=${room.id}&userName=${room.name}',
    );
  }

  /// 显示创建聊天室对话框
  void _showCreateRoomDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建聊天室'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '聊天室名称',
                hintText: '请输入聊天室名称',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: '描述（可选）',
                hintText: '请输入聊天室描述',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _createChatRoom(context, nameController.text.trim(), descController.text.trim());
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  /// 创建聊天室
  void _createChatRoom(BuildContext context, String name, String description) {
    final channelName = 'room_${DateTime.now().millisecondsSinceEpoch}';
    NavigatorUtils.push(
      context,
      '${MainRouter.audioChatPage}?channelName=$channelName&userName=$name',
    );
  }

  /// 显示更多选项
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('刷新列表'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 刷新聊天室列表
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('聊天设置'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 打开聊天设置
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 格式化时间
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else {
      return '${difference.inDays}天前';
    }
  }
}
