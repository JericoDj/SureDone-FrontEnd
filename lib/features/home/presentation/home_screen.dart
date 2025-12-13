import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/home/presentation/widgets/custom_home_app_bar.dart';
import 'package:suredone/features/home/presentation/widgets/featured_professionals.dart';
import 'package:suredone/features/home/presentation/widgets/promo_banner_carousel.dart';
import '../../../core/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {"name": "Delivery", "icon": Icons.delivery_dining, "route": "/delivery"},
      {"name": "Tutor", "icon": Icons.menu_book_rounded, "route": "/tutor"},
      {"name": "Fitness", "icon": Icons.fitness_center_rounded, "route": "/fitness"},
      {"name": "Pet Grooming", "icon": Icons.pets_rounded, "route": "/pet"},
      {"name": "Web/App Dev", "icon": Icons.computer_rounded, "route": "/dev"},
      {"name": "Home Cleaning", "icon": Icons.cleaning_services_rounded, "route": "/cleaning"},
      {"name": "Beauty", "icon": Icons.brush_rounded, "route": "/beauty"},
      {"name": "Repairs", "icon": Icons.build_rounded, "route": "/repairs"},
    ];


    // inside build()
    final promos = [
      Promo(
        imageUrl: 'https://via.placeholder.com/400x250.png?text=Home+Cleaning+Promo',
        title: '20% OFF Home Cleaning',
        subtitle: 'Save on your first booking — limited time only',
        onTap: () {},
      ),
      Promo(
        imageUrl: 'https://via.placeholder.com/400x250.png?text=Free+Delivery',
        title: 'Free Delivery (First 3 Orders)',
        subtitle: 'Enjoy no delivery fee for your first three orders',
        onTap: () {},
      ),
      Promo(
        imageUrl: 'https://via.placeholder.com/400x250.png?text=Fitness+Promo',
        title: 'Buy 4 Sessions, Get 1 Free',
        subtitle: 'Exclusive deal from our certified fitness coaches',
        onTap: () {},
      ),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomHomeAppBar(),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * .205,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // important!
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
                        title: item["name"] as String,
                        icon: item["icon"] as IconData,
                        onTap: () => context.push(item["route"] as String),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 5),
              PromoBannerCarousel(promos: promos, height: 150),

              // Featured Professionals
              const FeaturedProfessionalsWidget(),
              const SizedBox(height: 30),
            ],
          ),
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
    final height = MediaQuery.sizeOf(context).height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryCyan),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: height * .04, color: AppColors.primaryCyan),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: height * .012,
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
