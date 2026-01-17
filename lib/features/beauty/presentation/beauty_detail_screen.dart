import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/beauty/domain/beauty_models.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';

class BeautyDetailScreen extends StatelessWidget {
  final BeautyProfessional provider;

  const BeautyDetailScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    // Group services by category
    final servicesByCategory = <BeautyCategory, List<BeautyService>>{};
    for (var s in provider.services) {
      if (!servicesByCategory.containsKey(s.category)) {
        servicesByCategory[s.category] = [];
      }
      servicesByCategory[s.category]!.add(s);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    provider.avatarUrl,
                    fit: BoxFit.cover,
                     errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(provider.businessName.isNotEmpty ? provider.businessName : provider.name),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(provider.location, style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      if (provider.isHomeServiceAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Text("Home Service Available", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(provider.bio, style: const TextStyle(height: 1.5)),
                  const SizedBox(height: 24),

                  const Text("Services", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  // Service Menu Grouped
                  ...servicesByCategory.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(entry.key.label, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        ...entry.value.map((service) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(service.name),
                          subtitle: service.variants.isNotEmpty 
                            ? Text("Options: ${service.variants.map((v) => v.name).join(', ')}")
                            : null,
                          trailing: Text("₱${service.basePrice.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        )),
                        const Divider(),
                      ],
                    );
                  }),

                  const SizedBox(height: 16),
                  const Text("Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (provider.reviews.isEmpty)
                    const Padding(padding: EdgeInsets.only(top: 8), child: Text("No reviews yet"))
                  else
                    ...provider.reviews.map((r) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(child: Text(r.userName[0])),
                      title: Text(r.userName),
                      subtitle: Text(r.comment),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          Text(r.rating.toString()),
                        ],
                      ),
                    )),
                  
                  const SizedBox(height: 80), // Bottom padding for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))]),
          child: ElevatedButton(
            onPressed: () => context.push('/beauty/book', extra: provider),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.purple, // Beauty theme
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Book Appointment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
