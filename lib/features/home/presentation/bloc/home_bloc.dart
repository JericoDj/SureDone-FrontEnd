import 'package:bloc/bloc.dart';

import '../../domain/entities/promo.dart';
import 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    _loadPromos();
  }

  void _loadPromos() {
    emit(
      HomeState(
        services: state.services,
        promos: [
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
        ],
      ),
    );
  }
}
