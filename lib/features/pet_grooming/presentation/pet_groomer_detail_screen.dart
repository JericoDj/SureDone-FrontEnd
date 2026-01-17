import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/pet_grooming/domain/pet_models.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';

class PetGroomerDetailScreen extends StatelessWidget {
  final PetGroomer groomer;

  const PetGroomerDetailScreen({super.key, required this.groomer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Groomer Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image & Info
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.network(
                  groomer.avatarUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groomer.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(groomer.location, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  groomer.rating.toString(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About
                  const Text("About", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(groomer.bio, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
                  const SizedBox(height: 24),

                  // Supported Pets
                  const Text("Accepts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: groomer.supportedPetTypes.map((type) => Chip(
                      label: Text(type),
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      avatar: type == 'Dog' ? const Icon(Icons.pets, size: 16) : null,
                    )).toList(),
                  ),
                   const SizedBox(height: 24),

                  // Services
                  const Text("Services & Base Prices", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Column(
                    children: groomer.services.map((service) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(service.name),
                      trailing: Text("₱${service.price.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Comments
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      if (groomer.reviews.isNotEmpty)
                        Text("${groomer.reviews.length} reviews", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (groomer.reviews.isEmpty)
                    const Text("No reviews yet.", style: TextStyle(color: Colors.grey))
                  else
                    ...groomer.reviews.map((review) => _buildReviewCard(review)),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -4))],
          ),
          child: ElevatedButton(
            onPressed: () {
               context.push('/pet/book', extra: groomer);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Book Grooming", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.orange.withValues(alpha: 0.2),
                child: Text(review.userName[0], style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 2),
              Text(review.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(review.date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}
