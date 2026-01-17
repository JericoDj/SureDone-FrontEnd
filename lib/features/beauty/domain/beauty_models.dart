import 'package:suredone/features/tutor/domain/tutor_models.dart';

enum BeautyCategory {
  hair,
  makeup,
  nails,
  browsLashes,
  bodySkin,
  packages;

  String get label {
    switch (this) {
      case BeautyCategory.hair: return "Hair";
      case BeautyCategory.makeup: return "Makeup";
      case BeautyCategory.nails: return "Nails";
      case BeautyCategory.browsLashes: return "Brows & Lashes";
      case BeautyCategory.bodySkin: return "Body & Skin";
      case BeautyCategory.packages: return "Packages";
    }
  }
}

class ServiceVariant {
  final String name;
  final double price;

  const ServiceVariant({required this.name, required this.price});
}

class BeautyService {
  final String name;
  final double basePrice;
  final BeautyCategory category;
  final List<ServiceVariant> variants;

  const BeautyService({
    required this.name,
    required this.basePrice,
    required this.category,
    this.variants = const [],
  });
}

class BeautyProfessional {
  final String id;
  final String name;
  final String businessName; // Optional, can be same as name
  final String avatarUrl;
  final String bio;
  final String location;
  final double rating;
  final bool isHomeServiceAvailable;
  final double homeServiceFee;
  final List<BeautyService> services;
  final List<Review> reviews;

  const BeautyProfessional({
    required this.id,
    required this.name,
    this.businessName = '',
    required this.avatarUrl,
    required this.bio,
    required this.location,
    required this.rating,
    required this.isHomeServiceAvailable,
    this.homeServiceFee = 0.0,
    required this.services,
    required this.reviews,
  });
}
