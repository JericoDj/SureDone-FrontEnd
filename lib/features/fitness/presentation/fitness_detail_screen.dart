import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/fitness/domain/fitness_models.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';

class FitnessCoachDetailScreen extends StatelessWidget {
  final FitnessCoach coach;

  const FitnessCoachDetailScreen({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Coach Details"),
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
                  coach.avatarUrl,
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
                        coach.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
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
                                  coach.rating.toString(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "₱${coach.pricePerHour.toStringAsFixed(0)} / hour",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                  // Bio
                  const Text("About", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(coach.bio, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
                  const SizedBox(height: 24),

                  // Services
                  const Text("Services Offered", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: coach.services.map((service) => Chip(
                      label: Text(service),
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Focus Areas
                  const Text("Focus Areas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: coach.focusAreas.map((area) => Chip(
                      label: Text(area),
                      backgroundColor: Colors.grey[200],
                    )).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Comments / Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Comments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      if (coach.reviews.isNotEmpty)
                        Text("${coach.reviews.length} reviews", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (coach.reviews.isEmpty)
                    const Text("No reviews yet.", style: TextStyle(color: Colors.grey))
                  else
                    ...coach.reviews.map((review) => _buildReviewCard(review)),
                  
                  const SizedBox(height: 80), // Bottom padding for FAB
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
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -4)),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
               context.push('/fitness/book', extra: coach);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Book Coach", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
