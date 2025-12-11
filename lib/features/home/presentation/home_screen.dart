import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        "name": "Delivery",
        "icon": Icons.delivery_dining,
        "route": "/delivery",
      },
      {
        "name": "Tutor",
        "icon": Icons.menu_book_rounded,
        "route": "/tutor",
      },
      {
        "name": "Fitness",
        "icon": Icons.fitness_center_rounded,
        "route": "/fitness",
      },
      {
        "name": "Pet Grooming",
        "icon": Icons.pets_rounded,
        "route": "/pet",
      },
      {
        "name": "Web/App Dev",
        "icon": Icons.computer_rounded,
        "route": "/dev",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SureDone",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,       // 2 columns
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = services[index];
            return ServiceCard(
              title: item["name"] as String,
              icon: item["icon"] as IconData,
              onTap: () => context.push(item["route"] as String),
            );
          },
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryBlue),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: AppColors.primaryBlue),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
