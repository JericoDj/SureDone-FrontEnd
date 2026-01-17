import 'package:suredone/features/tutor/domain/tutor_models.dart';

enum FitnessCategory {
  personalTraining,
  sportsCoaching,
  classesGroupFitness,
  wellnessRecovery,
  onlineCoaching
}

class FitnessCoach {
  final String id;
  final String name;
  final String avatarUrl;
  final double rating;
  final double pricePerHour;
  final String bio;
  final List<String> services;
  final List<String> focusAreas;
  final FitnessCategory category;
  final List<Review> reviews;

  const FitnessCoach({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.pricePerHour,
    required this.bio,
    required this.services,
    required this.focusAreas,
    required this.category,
    this.reviews = const [],
  });
}
