import 'package:flutter/material.dart';
import 'package:suredone/features/activity/domain/activity_item.dart';

class BookingService extends ChangeNotifier {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal() {
    // Add Mock Data
    _bookings.addAll([
      const ActivityItem(
        id: 'mock_approved_1',
        title: 'Math Tutoring with Sarah',
        providerName: 'Sarah Jenkins',
        date: '1/20',
        price: '₱500',
        status: ActivityStatus.approved,
        imageUrl: 'https://i.pravatar.cc/150?u=Sarah',
        studentName: 'John Doe',
        gradeLevel: 'Primary 5',
        subjects: ['Math', 'Algebra'],
        paymentMethod: 'GCash',
      ),
      const ActivityItem(
        id: 'mock_requested_1',
        title: 'Science Lesson with Mike',
        providerName: 'Mike Ross',
        date: '1/22',
        price: '₱450',
        status: ActivityStatus.requested,
        imageUrl: 'https://i.pravatar.cc/150?u=Mike',
        studentName: 'Jane Doe',
        gradeLevel: 'Primary 3',
        subjects: ['Science'],
        paymentMethod: 'Cash',
      ),
       const ActivityItem(
        id: 'mock_completed_1',
        title: 'English Review with Emma',
        providerName: 'Emma Watson',
        date: '1/10',
        price: '₱600',
        status: ActivityStatus.completed,
        imageUrl: 'https://i.pravatar.cc/150?u=Emma',
        studentName: 'John Doe',
        gradeLevel: 'Primary 5',
        subjects: ['English'],
        paymentMethod: 'Maya',
      ),
    ]);
  }

  final List<ActivityItem> _bookings = [];

  List<ActivityItem> get bookings => List.unmodifiable(_bookings);

  void addBooking(ActivityItem booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void updateStatus(String id, ActivityStatus status) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      final old = _bookings[index];
      _bookings[index] = ActivityItem(
        id: old.id,
        title: old.title,
        providerName: old.providerName,
        date: old.date,
        price: old.price,
        status: status,
        imageUrl: old.imageUrl,
        studentName: old.studentName,
        gradeLevel: old.gradeLevel,
        subjects: old.subjects,
        paymentMethod: old.paymentMethod,
      );
      notifyListeners();
    }
  }
}
