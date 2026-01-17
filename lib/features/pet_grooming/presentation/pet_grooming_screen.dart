import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/pet_grooming/domain/pet_models.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart'; // For Review model

class PetGroomingScreen extends StatefulWidget {
  const PetGroomingScreen({super.key});

  @override
  State<PetGroomingScreen> createState() => _PetGroomingScreenState();
}

class _PetGroomingScreenState extends State<PetGroomingScreen> {
  final List<PetGroomer> _groomers = [
    PetGroomer(
      id: '1',
      name: 'Doggo Groomer PH',
      avatarUrl: 'https://images.unsplash.com/photo-1599305090598-fe179d501227?w=500&auto=format&fit=crop&q=60',
      bio: 'Professional grooming for all dog breeds. We treat your pets like family.',
      rating: 4.8,
      startingPrice: 500,
      location: 'Makati City',
      supportedPetTypes: ['Dog'],
      services: [
        PetService(name: 'Haircut', price: 500),
        PetService(name: 'Nail Trim', price: 150),
        PetService(name: 'Ear Clean', price: 150),
        PetService(name: 'Teeth Clean', price: 300),
        PetService(name: 'Creative Groom', price: 650),
      ],
      reviews: [
         Review(userName: 'Sarah L.', comment: 'My dog looks amazing!', rating: 5.0, date: '2 days ago'),
         Review(userName: 'Mike T.', comment: 'Very gentle with my puppy.', rating: 4.5, date: '1 week ago'),
      ],
    ),
    PetGroomer(
      id: '2',
      name: 'Purrfect Cuts',
      avatarUrl: 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?w=500&auto=format&fit=crop&q=60', // Valid cat image
      bio: 'Specialized cat grooming services. Stress-free environment for your feline friends.',
      rating: 4.9,
      startingPrice: 450,
      location: 'Quezon City',
      supportedPetTypes: ['Cat'],
      services: [
        PetService(name: 'Haircut', price: 550),
        PetService(name: 'Nail Trim', price: 150),
        PetService(name: 'Bath & Blowdry', price: 450),
      ],
      reviews: [
        Review(userName: 'Jenny K.', comment: 'Finally a groomer my cat loves!', rating: 5.0, date: '3 days ago'),
      ],
    ),
     PetGroomer(
      id: '3',
      name: 'Furry Friends Spa',
      avatarUrl: 'https://images.unsplash.com/photo-1623387641168-d9803ddd3f35?w=500&auto=format&fit=crop&q=60',
      bio: 'Full service spa for dogs and cats. We offer creative grooming and styles.',
      rating: 4.7,
      startingPrice: 600,
      location: 'BGC, Taguig',
      supportedPetTypes: ['Dog', 'Cat'],
      services: [
        PetService(name: 'Creative Groom', price: 700),
        PetService(name: 'Spa Treatment', price: 800),
        PetService(name: 'Nail Trim', price: 200),
      ],
      reviews: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Grooming', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _groomers.length,
        itemBuilder: (context, index) {
          final groomer = _groomers[index];
          return _buildGroomerCard(groomer);
        },
      ),
    );
  }

  Widget _buildGroomerCard(PetGroomer groomer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          context.push('/pet/details', extra: groomer);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  groomer.avatarUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groomer.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            groomer.location, 
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                     Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: groomer.services.take(3).map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(s.name, style: const TextStyle(fontSize: 10, color: Colors.blue)),
                      )).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Starts at ₱${groomer.startingPrice.toStringAsFixed(0)}", 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(groomer.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
