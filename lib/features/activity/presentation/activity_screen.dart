import 'package:flutter/material.dart';
import 'package:suredone/features/activity/domain/activity_item.dart';
import 'package:suredone/core/services/booking_service.dart';
import 'package:go_router/go_router.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    BookingService().addListener(_onBookingUpdate);
  }

  @override
  void dispose() {
    BookingService().removeListener(_onBookingUpdate);
    _tabController.dispose();
    super.dispose();
  }

  void _onBookingUpdate() {
    setState(() {});
  }

  List<ActivityItem> get _activities => BookingService().bookings;

  int _getCount(List<ActivityStatus> statuses) {
    if (statuses.isEmpty) return _activities.length; // All
    return _activities.where((a) => statuses.contains(a.status)).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Activity"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            _buildTab("All", []),
            _buildTab("Requested", [ActivityStatus.requested]),
            _buildTab("Approved", [ActivityStatus.approved]),
            _buildTab("Ongoing", [ActivityStatus.ongoing]),
            const Tab(text: "Completed"),
            const Tab(text: "Cancelled"), 
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivityList(_activities),
          _buildActivityList(_activities.where((a) => a.status == ActivityStatus.requested).toList()),
          _buildActivityList(_activities.where((a) => a.status == ActivityStatus.approved).toList()),
          _buildActivityList(_activities.where((a) => a.status == ActivityStatus.ongoing).toList()),
          _buildActivityList(_activities.where((a) => a.status == ActivityStatus.completed).toList()),
          _buildActivityList(_activities.where((a) => a.status == ActivityStatus.cancelled).toList()),
        ],
      ),
    );
  }

  Widget _buildTab(String text, List<ActivityStatus> statuses) {
    final count = _getCount(statuses);
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          if (count > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivityList(List<ActivityItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text("No activities found", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
              _showActivityDetails(context, item);
            },
            onLongPress: () {
                // Simulate approval on long press for demo
                if (item.status == ActivityStatus.requested) {
                    setState(() {
                        BookingService().updateStatus(item.id, ActivityStatus.approved);
                    });
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking Approved!")));
                }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(item.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(item.providerName, style: TextStyle(color: Colors.grey[600])),
                            const SizedBox(height: 4),
                            Text(item.date, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildStatusBadge(item.status),
                          const SizedBox(height: 8),
                          Text(item.price, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: item.status == ActivityStatus.approved || item.status == ActivityStatus.ongoing
                            ? () => context.push('/chat', extra: item)
                            : () {
                                if (item.status == ActivityStatus.requested) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chat available once approved")));
                                }
                              },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text("Chat"),
                        style: OutlinedButton.styleFrom(
                           // Grey out if not approved/ongoing
                           foregroundColor: item.status == ActivityStatus.approved || item.status == ActivityStatus.ongoing 
                              ? Theme.of(context).primaryColor 
                              : Colors.grey,
                           side: BorderSide(
                              color: item.status == ActivityStatus.approved || item.status == ActivityStatus.ongoing 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey[300]!
                           ),
                        ),
                      ),
                    ],
                  ),
                  if (item.subjects.isNotEmpty) ...[
                      const Divider(height: 24),
                      Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: item.subjects.map((s) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.grey[300]!)
                              ),
                              child: Text(s, style: const TextStyle(fontSize: 10)),
                          )).toList(),
                      )
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showActivityDetails(BuildContext context, ActivityItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              _detailRow("Provider", item.providerName),
              _detailRow("Date", item.date),
              _detailRow("Status", item.status.name.toUpperCase()),
              _detailRow("Price", item.price),
              const Divider(),
              _detailRow("Student", item.studentName),
              _detailRow("Grade", item.gradeLevel),
              _detailRow("Payment", item.paymentMethod),
              if (item.subjects.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text("Subjects:", style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 4,
                  children: item.subjects.map((s) => Chip(
                    label: Text(s, style: const TextStyle(fontSize: 10)), 
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (item.status == ActivityStatus.approved || item.status == ActivityStatus.ongoing)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/chat', extra: item);
              },
              child: const Text("Chat"),
            )
          else if (item.status == ActivityStatus.requested)
             TextButton(
              onPressed: null, // Disabled
              child: const Text("Chat (Wait for Approval)", style: TextStyle(color: Colors.grey)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80, 
            child: Text("$label:", style: TextStyle(color: Colors.grey[600], fontSize: 13))
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ActivityStatus status) {
    Color color;
    String text;

    switch (status) {
      case ActivityStatus.ongoing:
        color = Colors.blue;
        text = "Ongoing";
        break;
      case ActivityStatus.completed:
        color = Colors.green;
        text = "Completed";
        break;
      case ActivityStatus.cancelled:
        color = Colors.red;
        text = "Cancelled";
        break;
      case ActivityStatus.requested:
        color = Colors.orange;
        text = "Requested";
        break;
      case ActivityStatus.approved:
        color = Colors.green;
        text = "Approved";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
