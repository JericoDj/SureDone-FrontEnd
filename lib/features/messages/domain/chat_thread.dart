class ChatThread {
  final String id;
  final String senderName;
  final String senderAvatarUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const ChatThread({
    required this.id,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}
