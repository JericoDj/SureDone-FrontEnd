import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suredone/features/activity/domain/activity_item.dart';

class ChatScreen extends StatefulWidget {
  final ActivityItem activity;

  const ChatScreen({super.key, required this.activity});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  
  // Mock Messages
  final List<Map<String, dynamic>> _messages = [
    {'sender': 'tutor', 'text': 'Hello! Thanks for booking. I am looking forward to our session.', 'time': '10:00 AM'},
    {'sender': 'me', 'text': 'Hi! Yes, I am excited too. See you then.', 'time': '10:05 AM'},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'me',
        'text': _messageController.text,
        'time': _formatTime(DateTime.now()),
      });
      _messageController.clear();
    });
    _scrollToBottom();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _messages.add({
          'sender': 'me',
          'image': image.path,
          'time': _formatTime(DateTime.now()),
        });
      });
      _scrollToBottom();
    }
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.activity.imageUrl),
              radius: 16,
            ),
            const SizedBox(width: 8),
            Text(widget.activity.providerName, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['sender'] == 'me';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isMe ? Theme.of(context).primaryColor : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                        bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                         if (msg.containsKey('image'))
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(msg['image']), width: 150, fit: BoxFit.cover),
                          )
                        else
                          Text(
                            msg['text'],
                            style: TextStyle(color: isMe ? Colors.white : Colors.black),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.attach_file),
                    color: Colors.grey[600],
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
