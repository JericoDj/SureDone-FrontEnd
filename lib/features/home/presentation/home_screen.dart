import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/home/presentation/widgets/custom_home_app_bar.dart';
import 'package:suredone/features/home/presentation/widgets/featured_professionals.dart';
import 'package:suredone/features/home/presentation/widgets/promo_banner_carousel.dart';
import 'package:suredone/features/home/presentation/widgets/services_grid.dart';


import 'bloc/home_bloc.dart';
import 'bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomHomeAppBar(),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServicesGrid(services: state.services),
                  const SizedBox(height: 5),
                  PromoBannerCarousel(
                    promos: state.promos, // ✅ FIX 2
                    height: 150,
                  ),
                  const FeaturedProfessionalsWidget(),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
