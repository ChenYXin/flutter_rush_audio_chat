import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widget/cache_image.dart';
import '../viewmodel/chat_viewmodel.dart';

/// 聊天页面Fragment
class ChatFragment extends StatefulWidget {
  const ChatFragment({super.key});

  @override
  State<ChatFragment> createState() => _ChatFragmentState();
}

class _ChatFragmentState extends State<ChatFragment> {
  /// 搜索控制器
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==================== UI构建方法 ====================

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('聊天'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showMessage('添加聊天功能开发中...'),
              ),
            ],
          ),
          body: Column(
            children: [
              // 搜索框
              _buildSearchBar(viewModel),
              // 聊天列表
              Expanded(
                child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildChatList(viewModel),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建搜索框
  Widget _buildSearchBar(ChatViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索聊天',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  viewModel.clearSearch();
                },
              )
            : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        onChanged: (value) => viewModel.searchChats(value),
      ),
    );
  }

  /// 构建聊天列表
  Widget _buildChatList(ChatViewModel viewModel) {
    final chatList = viewModel.filteredChatList;

    if (chatList.isEmpty) {
      return const Center(
        child: Text('暂无聊天记录'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refreshChats(),
      child: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          return _buildChatItem(chat, viewModel);
        },
      ),
    );
  }

  /// 构建聊天项
  Widget _buildChatItem(ChatItem chat, ChatViewModel viewModel) {
    return ListTile(
      leading: Stack(
        children: [
          SvCacheImage(
            imageUrl: chat.avatar,
            width: 50,
            height: 50,
            radius: 25,
            fit: BoxFit.cover,
          ),
          if (chat.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        chat.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            viewModel.getFormattedTime(chat.timestamp),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          if (chat.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                chat.unreadCount > 99 ? '99+' : chat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        viewModel.onChatItemTap(chat);
        _showMessage('进入与${chat.name}的聊天');
      },
      onLongPress: () => _showChatOptions(chat, viewModel),
    );
  }

  /// 显示聊天选项
  void _showChatOptions(ChatItem chat, ChatViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildChatOptionsSheet(chat, viewModel),
    );
  }

  /// 构建聊天选项底部弹窗
  Widget _buildChatOptionsSheet(ChatItem chat, ChatViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.mark_chat_read),
            title: const Text('标记为已读'),
            onTap: () {
              Navigator.pop(context);
              viewModel.markAsRead(chat.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('删除聊天', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              viewModel.deleteChat(chat.id);
            },
          ),
        ],
      ),
    );
  }

  /// 显示消息
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
