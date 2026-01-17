enum ActivityStatus { requested, approved, ongoing, completed, cancelled }

class ActivityItem {
  final String id;
  final String title;
  final String providerName;
  final String date;
  final String price;
  final ActivityStatus status;
  final String imageUrl;
  // New fields for detailed booking info
  final String studentName;
  final String gradeLevel;
  final List<String> subjects;
  final String paymentMethod;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.providerName,
    required this.date,
    required this.price,
    required this.status,
    required this.imageUrl,
    this.studentName = '',
    this.gradeLevel = '',
    this.subjects = const [],
    this.paymentMethod = '',
  });
}
