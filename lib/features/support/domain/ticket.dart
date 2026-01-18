enum TicketStatus { open, resolved, pending }

class SupportTicket {
  final String id;
  final String subject;
  final String message;
  final TicketStatus status;
  final DateTime createdAt;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.message,
    this.status = TicketStatus.open,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  SupportTicket copyWith({
    String? id,
    String? subject,
    String? message,
    TicketStatus? status,
    DateTime? createdAt,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
