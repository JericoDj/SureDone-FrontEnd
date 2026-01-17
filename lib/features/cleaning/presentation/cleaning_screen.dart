import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/cleaning/domain/cleaning_models.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';

class CleaningScreen extends StatefulWidget {
  const CleaningScreen({super.key});

  @override
  State<CleaningScreen> createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen> {
  final List<Cleaner> _cleaners = [
    Cleaner(
      id: '1',
      name: 'Clean & Shine',
      avatarUrl: 'https://images.unsplash.com/photo-1581578731117-104f2a412727?w=500&auto=format&fit=crop&q=60',
      bio: 'Top-rated cleaning service specializing in deep cleaning and move-in/out services.',
      location: 'Makati & BGC',
      rating: 4.8,
      startingPrice: 200, // Hourly starts
      services: [
        CleaningService(name: 'General Cleaning', price: 200), // Per hour
        CleaningService(name: 'Deep Cleaning', price: 1000), // Flat starts
        CleaningService(name: 'Bathroom Cleaning', price: 200, isPerRoom: true),
        CleaningService(name: 'Kitchen Cleaning', price: 500),
      ],
      reviews: [
        Review(userName: 'Alice M.', comment: 'Spotless cleaning!', rating: 5.0, date: '1 day ago'),
      ],
    ),
    Cleaner(
      id: '2',
      name: 'Sparkle Home',
      avatarUrl: 'https://images.unsplash.com/photo-1556910103-1c02745a30bf?w=500&auto=format&fit=crop&q=60',
      bio: 'Reliable and affordable home cleaning. We verify all our staff.',
      location: 'Mandaluyong',
      rating: 4.6,
      startingPrice: 150,
      services: [
        CleaningService(name: 'General Cleaning', price: 150),
        CleaningService(name: 'Laundry', price: 300),
        CleaningService(name: 'Ironing', price: 250),
      ],
      reviews: [],
    ),
    Cleaner(
      id: '3',
      name: 'EcoClean Pros',
      avatarUrl: 'https://images.unsplash.com/photo-1527515545081-5db817172677?w=500&auto=format&fit=crop&q=60',
      bio: 'We use eco-friendly products safe for pets and kids.',
      location: 'Pasig City',
      rating: 4.9,
      startingPrice: 300,
      services: [
        CleaningService(name: 'Deep Cleaning', price: 1500),
        CleaningService(name: 'Post-Renovation', price: 2500),
        CleaningService(name: 'General Cleaning', price: 300),
      ],
      reviews: [
         Review(userName: 'Tom R.', comment: 'Smells great and clean!', rating: 5.0, date: '2 weeks ago'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Cleaning', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cleaners.length,
        itemBuilder: (context, index) {
          final cleaner = _cleaners[index];
          return _buildCleanerCard(cleaner);
        },
      ),
    );
  }

  Widget _buildCleanerCard(Cleaner cleaner) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          context.push('/cleaning/details', extra: cleaner);
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
                  cleaner.avatarUrl,
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
                      cleaner.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(cleaner.location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: cleaner.services.take(3).map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.teal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(s.name, style: const TextStyle(fontSize: 10, color: Colors.teal)),
                      )).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Starts at ₱${cleaner.startingPrice.toStringAsFixed(0)}", 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(cleaner.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
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
