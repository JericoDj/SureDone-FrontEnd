import 'package:suredone/features/tutor/domain/tutor_models.dart';

enum RepairCategory {
  electrical,
  plumbing,
  appliance,
  ac,
  handyman,
  carpentry;

  String get label {
    switch (this) {
      case RepairCategory.electrical: return "Electrical";
      case RepairCategory.plumbing: return "Plumbing";
      case RepairCategory.appliance: return "Appliance";
      case RepairCategory.ac: return "AC / Aircon";
      case RepairCategory.handyman: return "Handyman";
      case RepairCategory.carpentry: return "Carpentry";
    }
  }
}

class RepairService {
  final String name;
  final double basePrice;
  final RepairCategory category;

  const RepairService({
    required this.name,
    required this.basePrice,
    required this.category,
  });
}

class RepairProfessional {
  final String id;
  final String name;
  final String businessName; // Optional, can be same as name
  final String avatarUrl;
  final String bio;
  final String location;
  final double rating;
  final double diagnosticFee;
  final double emergencyFee;
  final List<RepairService> services;
  final List<Review> reviews;

  const RepairProfessional({
    required this.id,
    required this.name,
    this.businessName = '',
    required this.avatarUrl,
    required this.bio,
    required this.location,
    required this.rating,
    required this.diagnosticFee,
    required this.emergencyFee,
    required this.services,
    required this.reviews,
  });
}
