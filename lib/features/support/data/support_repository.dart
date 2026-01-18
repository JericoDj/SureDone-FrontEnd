import 'package:flutter/material.dart';
import 'package:suredone/features/support/domain/ticket.dart';

class SupportRepository {
  static final SupportRepository _instance = SupportRepository._internal();
  factory SupportRepository() => _instance;
  SupportRepository._internal();

  final ValueNotifier<List<SupportTicket>> ticketsNotifier = ValueNotifier([
    SupportTicket(
      id: "T-1001",
      subject: "Issue with Booking",
      message: "I cannot reschedule my cleaning appointment.",
      status: TicketStatus.resolved,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    SupportTicket(
      id: "T-1002",
      subject: "Payment Pending",
      message: "My payment went through but status says pending.",
      status: TicketStatus.open,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
  ]);

  void addTicket(SupportTicket ticket) {
    final currentList = ticketsNotifier.value;
    ticketsNotifier.value = [ticket, ...currentList];
  }
}
