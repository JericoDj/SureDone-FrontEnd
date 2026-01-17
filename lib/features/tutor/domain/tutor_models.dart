class Review {
  final String userName;
  final String comment;
  final double rating;
  final String date;

  const Review({
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
  });
}

class Tutor {
  final String id;
  final String name;
  final String avatarUrl;
  final List<String> subjects;
  final double pricePerHour;
  final double rating;
  final String about;
  final List<String> achievements;
  final List<String> availability;
  final List<Review> reviews;

  const Tutor({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.subjects,
    required this.pricePerHour,
    required this.rating,
    required this.about,
    required this.achievements,
    required this.availability,
    required this.reviews,
  });
}
