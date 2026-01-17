import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/home/presentation/widgets/services_card.dart';

import '../../domain/entities/service_item.dart';


class ServicesGrid extends StatelessWidget {
  final List<ServiceItem> services;

  const ServicesGrid({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: services.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final item = services[index];
          return ServiceCard(
            title: item.name,
            icon: item.icon,
            onTap: () => context.push(item.route),
          );
        },
      ),
    );
  }
}
