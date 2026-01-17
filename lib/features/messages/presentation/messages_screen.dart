import 'package:flutter/material.dart';
import 'package:suredone/features/messages/domain/chat_thread.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<ChatThread> _chats = [
    ChatThread(
      id: '1',
      senderName: 'Alice Cleaner',
      senderAvatarUrl: 'https://via.placeholder.com/150',
      lastMessage: 'I am on my way!',
      time: '12:30 PM',
      unreadCount: 2,
      isOnline: true,
    ),
    ChatThread(
      id: '2',
      senderName: 'John Doe',
      senderAvatarUrl: 'https://via.placeholder.com/150',
      lastMessage: 'Thanks for the session. See you next...',
      time: 'Yesterday',
      unreadCount: 0,
      isOnline: false,
    ),
    ChatThread(
      id: '3',
      senderName: 'Support',
      senderAvatarUrl: 'https://via.placeholder.com/150',
      lastMessage: 'Your refund has been processed.',
      time: 'Jan 10',
      unreadCount: 0,
      isOnline: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(chat.senderAvatarUrl),
                ),
                if (chat.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
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
              chat.senderName,
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
                  chat.time,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                if (chat.unreadCount > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      chat.unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ],
            ),
            onTap: () {
              // Navigate to chat detail
            },
          );
        },
      ),
    );
  }
}
