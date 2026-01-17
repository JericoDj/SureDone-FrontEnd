import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/repairs/domain/repair_models.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';

class RepairsScreen extends StatefulWidget {
  const RepairsScreen({super.key});

  @override
  State<RepairsScreen> createState() => _RepairsScreenState();
}

class _RepairsScreenState extends State<RepairsScreen> {
  // Mock Data
  final List<RepairProfessional> _providers = [
    RepairProfessional(
      id: 'r1',
      name: 'Mario Rossi',
      businessName: 'FixRight Services',
      avatarUrl: 'https://images.unsplash.com/photo-1581092921461-eab62e97a783?w=500&auto=format&fit=crop&q=60', // Industrial/Worker
      bio: 'Expert AC technicians and appliance repair specialists with 10 years experience.',
      location: 'Quezon City',
      rating: 4.8,
      diagnosticFee: 300,
      emergencyFee: 300,
      services: [
        RepairService(name: 'AC Cleaning', basePrice: 800, category: RepairCategory.ac),
        RepairService(name: 'AC Checkup', basePrice: 300, category: RepairCategory.ac),
        RepairService(name: 'Freon Charge', basePrice: 1500, category: RepairCategory.ac),
        RepairService(name: 'Fridge Repair', basePrice: 500, category: RepairCategory.appliance),
      ],
      reviews: [
        Review(userName: "John D.", comment: "Fast and professional AC cleaning.", rating: 5.0, date: "1 week ago"),
      ],
    ),
    RepairProfessional(
      id: 'r2',
      name: 'Luigi Verde',
      businessName: 'QuickFix Handyman',
      avatarUrl: 'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=500&auto=format&fit=crop&q=60',
      bio: 'All-around handyman for plumbing, electrical, and carpentry.',
      location: 'Makati',
      rating: 4.6,
      diagnosticFee: 250,
      emergencyFee: 500,
      services: [
        RepairService(name: 'Faucet Repair', basePrice: 400, category: RepairCategory.plumbing),
        RepairService(name: 'Drain Unclogging', basePrice: 500, category: RepairCategory.plumbing),
        RepairService(name: 'Outlet Replace', basePrice: 300, category: RepairCategory.electrical),
        RepairService(name: 'Door Lock Fix', basePrice: 350, category: RepairCategory.handyman),
      ],
      reviews: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Repairs & Home Services")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _providers.length,
        itemBuilder: (context, index) {
          return _buildProviderCard(_providers[index]);
        },
      ),
    );
  }

  Widget _buildProviderCard(RepairProfessional provider) {
    // Get unique categories for badges
    final categories = provider.services.map((s) => s.category).toSet().toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.push('/repairs/details', extra: provider),
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
                    width: 80, height: 80, color: Colors.grey[300], child: const Icon(Icons.build, color: Colors.grey)),
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
                      runSpacing: 4,
                      children: categories.map((c) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.blueGrey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(c.label, style: const TextStyle(fontSize: 10, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                      )).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Diagnostic: ₱${provider.diagnosticFee.toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
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
