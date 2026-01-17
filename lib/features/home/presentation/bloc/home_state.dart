import 'package:flutter/material.dart';

import '../../domain/entities/promo.dart';
import '../../domain/entities/service_item.dart';

class HomeState {
  final List<ServiceItem> services;
  final List<Promo> promos;

  const HomeState({
    required this.services,
    required this.promos,
  });

  factory HomeState.initial() {
    return HomeState(
      services: const [

        ServiceItem(
          name: 'Tutor',
          icon: Icons.menu_book_rounded,
          route: '/tutor',
        ),
        ServiceItem(
          name: 'Fitness',
          icon: Icons.fitness_center_rounded,
          route: '/fitness',
        ),
        ServiceItem(
          name: 'Pet Grooming',
          icon: Icons.pets_rounded,
          route: '/pet',
        ),

        ServiceItem(
          name: 'Home Cleaning',
          icon: Icons.cleaning_services_rounded,
          route: '/cleaning',
        ),
        ServiceItem(
          name: 'Beauty',
          icon: Icons.brush_rounded,
          route: '/beauty',
        ),
        ServiceItem(
          name: 'Repairs',
          icon: Icons.build_rounded,
          route: '/repairs',
        ),
      ],
      promos: const [],
    );
  }
}
