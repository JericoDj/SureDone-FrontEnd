import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/support/data/support_repository.dart';
import 'package:suredone/features/support/domain/ticket.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Help Center"),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: "FAQ"),
              Tab(text: "My Tickets"),
            ],
          ),
        ),
        body: const TabBarView(children: [_FAQTab(), _MyTicketsTab()]),
        floatingActionButton: _MyTicketsFab(),
      ),
    );
  }
}

class _MyTicketsFab extends StatelessWidget {
  const _MyTicketsFab();

  @override
  Widget build(BuildContext context) {
    // Only show FAB if we are potentially on the tickets tab (or always show it,
    // simpler UX is fine to always show it or let it be global for this screen)
    // To strictly match "visible on Tickets tab", we can leave it always visible
    // as it is relevant to "Help Center" in general.
    return FloatingActionButton.extended(
      onPressed: () => context.push('/profile/help/new-ticket'),
      label: const Text("New Ticket"),
      icon: const Icon(Icons.add),
      backgroundColor: Colors.blueAccent,
    );
  }
}

class _FAQTab extends StatelessWidget {
  const _FAQTab();

  final List<Map<String, String>> faqs = const [
    {
      "question": "How do I book a service?",
      "answer":
          "Go to the Home tab, select a category (e.g., Cleaning), choose your preferences, and proceed to booking.",
    },
    {
      "question": "Can I cancel my booking?",
      "answer":
          "Yes, you can cancel up to 2 hours before the scheduled time from the Activity tab.",
    },
    {
      "question": "How do vouchers work?",
      "answer":
          "claimed vouchers can be applied at checkout. You can view your vouchers in the Vouchers page.",
    },
    {
      "question": "Is payment secure?",
      "answer":
          "Yes, we use industry-standard encryption for all transactions.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: ExpansionTile(
            title: Text(
              faq["question"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(faq["answer"]!),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MyTicketsTab extends StatelessWidget {
  const _MyTicketsTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SupportTicket>>(
      valueListenable: SupportRepository().ticketsNotifier,
      builder: (context, tickets, child) {
        if (tickets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  "No tickets yet",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            80,
          ), // Bottom padding for FAB
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  ticket.subject,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      ticket.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "#${ticket.id} • ${_formatDate(ticket.createdAt)}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
                trailing: _buildStatusChip(ticket.status),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusChip(TicketStatus status) {
    Color color;
    String label;
    switch (status) {
      case TicketStatus.open:
        color = Colors.orange;
        label = "Open";
        break;
      case TicketStatus.resolved:
        color = Colors.green;
        label = "Resolved";
        break;
      case TicketStatus.pending:
        color = Colors.blue;
        label = "Pending";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple formatter
    return "${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
