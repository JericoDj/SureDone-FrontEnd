import 'package:suredone/features/tutor/domain/tutor_models.dart'; // Reuse Review model

class PetService {
  final String name;
  final double price;

  const PetService({required this.name, required this.price});
}

class PetGroomer {
  final String id;
  final String name;
  final String avatarUrl;
  final String bio;
  final double rating;
  final double startingPrice;
  final List<PetService> services;
  final List<Review> reviews;
  final List<String> supportedPetTypes;
  final String location;

  const PetGroomer({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.bio,
    required this.rating,
    required this.startingPrice,
    required this.services,
    required this.reviews,
    required this.supportedPetTypes,
    required this.location,
  });
}
