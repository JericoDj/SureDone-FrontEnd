import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/repairs/domain/repair_models.dart';

class RepairDetailScreen extends StatelessWidget {
  final RepairProfessional provider;

  const RepairDetailScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final servicesByCategory = <RepairCategory, List<RepairService>>{};
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
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.blueGrey),
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
                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: Column(children: [
                            const Text("Diagnostic Fee", style: TextStyle(fontSize: 12, color: Colors.blue)),
                            Text("₱${provider.diagnosticFee.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ]),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: Column(children: [
                            const Text("Emergency Fee", style: TextStyle(fontSize: 12, color: Colors.red)),
                            Text("₱${provider.emergencyFee.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(provider.bio, style: const TextStyle(height: 1.5)),
                  const SizedBox(height: 24),
                  
                  const Text("Services", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
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
                          trailing: Text("₱${service.basePrice.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        )),
                        const Divider(),
                      ],
                    );
                  }),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset:const Offset(0, -2))]),
          child: ElevatedButton(
            onPressed: () => context.push('/repairs/book', extra: provider),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Book Service", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
