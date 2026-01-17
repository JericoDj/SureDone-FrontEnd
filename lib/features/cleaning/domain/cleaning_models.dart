import 'package:suredone/features/tutor/domain/tutor_models.dart';

enum UnitType {
  studio,
  oneBR,
  twoBR,
  house;

  double get multiplier {
    switch (this) {
      case UnitType.studio: return 1.0;
      case UnitType.oneBR: return 1.2;
      case UnitType.twoBR: return 1.4;
      case UnitType.house: return 1.8;
    }
  }

  String get label {
    switch (this) {
      case UnitType.studio: return "Studio";
      case UnitType.oneBR: return "1BR";
      case UnitType.twoBR: return "2BR";
      case UnitType.house: return "House";
    }
  }
}

class CleaningService {
  final String name;
  final double price;
  final bool isPerRoom;

  const CleaningService({
    required this.name, 
    required this.price, 
    this.isPerRoom = false
  });
}

class Cleaner {
  final String id;
  final String name;
  final String avatarUrl;
  final String bio;
  final String location;
  final double rating;
  final double startingPrice;
  final List<CleaningService> services;
  final List<Review> reviews;

  const Cleaner({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.bio,
    required this.location,
    required this.rating,
    required this.startingPrice,
    required this.services,
    required this.reviews,
  });
}
