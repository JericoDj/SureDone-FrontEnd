import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/cleaning/domain/cleaning_models.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';

class CleanerDetailScreen extends StatelessWidget {
  final Cleaner cleaner;

  const CleanerDetailScreen({super.key, required this.cleaner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Cleaner Details"),
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
            // Header
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.network(
                  cleaner.avatarUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey,
                    child: const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 50)),
                  ),
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
                        cleaner.name,
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(cleaner.location, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 8),
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
                              cleaner.rating.toString(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
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
                  Text(cleaner.bio, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
                  const SizedBox(height: 24),

                  // Services
                  const Text("Services Menu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Column(
                    children: cleaner.services.map((service) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(service.name),
                      subtitle: service.isPerRoom ? const Text("Per Room / Area") : null,
                      trailing: Text("₱${service.price.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Reviews
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      if (cleaner.reviews.isNotEmpty)
                        Text("${cleaner.reviews.length} reviews", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (cleaner.reviews.isEmpty)
                    const Text("No reviews yet.", style: TextStyle(color: Colors.grey))
                  else
                    ...cleaner.reviews.map((review) => _buildReviewCard(review)),
                  
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
               context.push('/cleaning/book', extra: cleaner);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal, // Brand color for cleaning usually
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Book Service", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                backgroundColor: Colors.teal.withValues(alpha: 0.2),
                child: Text(review.userName[0], style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
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
