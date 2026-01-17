import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/beauty/domain/beauty_models.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';

class BeautyScreen extends StatefulWidget {
  const BeautyScreen({super.key});

  @override
  State<BeautyScreen> createState() => _BeautyScreenState();
}

class _BeautyScreenState extends State<BeautyScreen> {
  BeautyCategory? _selectedCategory;

  final List<BeautyProfessional> _providers = [
    BeautyProfessional(
      id: '1',
      name: 'Reina Styles',
      businessName: 'Glam by Reina',
      avatarUrl: 'https://images.unsplash.com/photo-1595152772835-219674b2a8a6?w=500&auto=format&fit=crop&q=60',
      bio: 'Professional makeup artist and hair stylist for weddings and events.',
      location: 'BGC, Taguig',
      rating: 4.9,
      isHomeServiceAvailable: true,
      homeServiceFee: 150.0,
      services: [
        BeautyService(
          name: 'Haircut',
          basePrice: 300,
          category: BeautyCategory.hair,
        ),
        BeautyService(
          name: 'Hair Color',
          basePrice: 900, // Starts at short
          category: BeautyCategory.hair,
          variants: [
            ServiceVariant(name: 'Short', price: 900),
            ServiceVariant(name: 'Medium', price: 1200),
            ServiceVariant(name: 'Long', price: 1500),
          ],
        ),
        BeautyService(
            name: 'Event Makeup', 
            basePrice: 1500, 
            category: BeautyCategory.makeup,
            variants: [
                ServiceVariant(name: 'Day Look', price: 1500),
                ServiceVariant(name: 'Evening Glam', price: 2000),
            ]
        ),
      ],
      reviews: [
        Review(userName: "Carla T.", comment: "Love my new hair color!", rating: 5.0, date: "3 days ago"),
      ],
    ),
    BeautyProfessional(
      id: '2',
      name: 'Glow Lounge',
      businessName: 'Glow Lounge Manila',
      avatarUrl: 'https://images.unsplash.com/photo-1629878297059-45041a966774?w=500&auto=format&fit=crop&q=60', // Nails/Spa image
      bio: 'Premium nail salon and spa services.',
      location: 'Quezon City',
      rating: 4.7,
      isHomeServiceAvailable: false,
      services: [
        BeautyService(name: 'Gel Manicure', basePrice: 600, category: BeautyCategory.nails),
        BeautyService(name: 'Spa Pedicure', basePrice: 450, category: BeautyCategory.nails),
        BeautyService(
            name: 'Lash Lift', 
            basePrice: 700, 
            category: BeautyCategory.browsLashes
        ),
      ],
      reviews: [],
    ),
     BeautyProfessional(
      id: '3',
      name: 'Barber Bros',
      businessName: 'Barber Bros Co.',
      avatarUrl: 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=500&auto=format&fit=crop&q=60',
      bio: 'Classic cuts and modern styles for men.',
      location: 'Makati',
      rating: 4.8,
      isHomeServiceAvailable: true,
      homeServiceFee: 100,
      services: [
        BeautyService(name: 'Standard Cut', basePrice: 350, category: BeautyCategory.hair),
        BeautyService(name: 'Beard Trim', basePrice: 200, category: BeautyCategory.hair),
      ],
      reviews: [],
    ),
  ];

  List<BeautyProfessional> get _filteredProviders {
    if (_selectedCategory == null) return _providers;
    return _providers.where((p) => p.services.any((s) => s.category == _selectedCategory)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Beauty & Grooming")),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                 FilterChip(
                  label: const Text("All"),
                  selected: _selectedCategory == null,
                  onSelected: (selected) => setState(() => _selectedCategory = null),
                ),
                const SizedBox(width: 8),
                ...BeautyCategory.values.map((cat) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat.label),
                    selected: _selectedCategory == cat,
                    onSelected: (selected) => setState(() => _selectedCategory = selected ? cat : null),
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredProviders.length,
              itemBuilder: (context, index) {
                return _buildProviderCard(_filteredProviders[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(BeautyProfessional provider) {
    final startingPrice = provider.services.isEmpty ? 0 : provider.services.map((s) => s.basePrice).reduce((a, b) => a < b ? a : b);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () => context.push('/beauty/details', extra: provider),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  provider.avatarUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80, 
                    height: 80, 
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.businessName.isNotEmpty ? provider.businessName : provider.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(provider.location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children: provider.services.take(3).map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(s.name, style: const TextStyle(fontSize: 10, color: Colors.purple)),
                      )).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Starts at ₱${startingPrice.toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        if (provider.rating > 0)
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(provider.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
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
