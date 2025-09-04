import 'package:flutter/material.dart';
import '../../chat/page/chat_room_list_page.dart';

/// 聊天页面Fragment
class ChatFragment extends StatefulWidget {
  const ChatFragment({super.key});

  @override
  State<ChatFragment> createState() => _ChatFragmentState();
}

class _ChatFragmentState extends State<ChatFragment> {
  @override
  Widget build(BuildContext context) {
    return const ChatRoomListPage();
  }
}
