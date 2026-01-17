
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Shell with bottom navigation bar
import 'package:suredone/features/navigation/app_shell.dart';

// Main tabs
import 'package:suredone/features/home/presentation/home_screen.dart';
import 'package:suredone/features/activity/presentation/activity_screen.dart';
import 'package:suredone/features/messages/presentation/messages_screen.dart';
import 'package:suredone/features/wallet/presentation/wallet_screen.dart';
import 'package:suredone/features/profile/presentation/profile_screen.dart';

// Other pages
import 'package:suredone/features/auth/presentation/login_screen.dart';

import 'package:suredone/features/tutor/presentation/tutor_screen.dart';
import 'package:suredone/features/fitness/presentation/fitness_screen.dart';
import 'package:suredone/features/pet_grooming/presentation/pet_grooming_screen.dart';


import '../features/cleaning/domain/cleaning_models.dart';
import '../features/home/presentation/bloc/home_bloc.dart';

import 'package:suredone/features/tutor/presentation/tutor_booking_screen.dart';
import 'package:suredone/features/tutor/presentation/tutor_detail_screen.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';
import 'package:suredone/features/activity/domain/activity_item.dart';
import 'package:suredone/features/fitness/domain/fitness_models.dart';
import 'package:suredone/features/fitness/presentation/fitness_detail_screen.dart';
import 'package:suredone/features/fitness/presentation/fitness_booking_screen.dart';
import 'package:suredone/features/chat/presentation/chat_screen.dart';
// Consolidated imports
import 'package:suredone/features/pet_grooming/domain/pet_models.dart';
import 'package:suredone/features/pet_grooming/presentation/pet_groomer_detail_screen.dart';
import 'package:suredone/features/pet_grooming/presentation/pet_booking_screen.dart';
import 'package:suredone/features/cleaning/presentation/cleaning_screen.dart';
import 'package:suredone/features/cleaning/presentation/cleaner_detail_screen.dart';
import 'package:suredone/features/cleaning/presentation/cleaning_booking_screen.dart';
import 'package:suredone/features/beauty/domain/beauty_models.dart';
import 'package:suredone/features/beauty/presentation/beauty_screen.dart';
import 'package:suredone/features/beauty/presentation/beauty_detail_screen.dart';
import 'package:suredone/features/beauty/presentation/beauty_booking_screen.dart';
import 'package:suredone/features/repairs/domain/repair_models.dart';
import 'package:suredone/features/repairs/presentation/repairs_screen.dart';
import 'package:suredone/features/repairs/presentation/repair_detail_screen.dart';
import 'package:suredone/features/repairs/presentation/repair_booking_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: "/home",

  routes: [
     GoRoute(
      path: '/chat',
      builder: (context, state) {
        final activity = state.extra as ActivityItem;
        return ChatScreen(activity: activity);
      }
    ),
    /// LOGIN (NO NAV BAR)
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),

    /// SHELL ROUTE (BOTTOM NAV SHOWS ONLY HERE)
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => HomeBloc(),
              child: const HomePage(),
            );
          },
        ),
        GoRoute(path: '/activity', builder: (_, __)  => const ActivityScreen()),
        GoRoute(path: '/messages', builder: (_, __) => const MessagesScreen()),
        GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),

    /// OUTSIDE SHELL → NO BOTTOM NAV

    GoRoute(
      path: '/tutor',
      builder: (context, state) =>
      const TutorScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final tutor = state.extra as Tutor;
            return TutorDetailScreen(tutor: tutor);
          },
        ),
        GoRoute(
          path: 'book',
          builder: (context, state) {
            final tutor = state.extra as Tutor;
            return TutorBookingScreen(tutor: tutor);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/fitness',
      builder: (context, state) =>
      const FitnessScreen(),

      routes: [
         GoRoute(
          path: 'details',
          builder: (context, state) {
            final coach = state.extra as FitnessCoach;
            return FitnessCoachDetailScreen(coach: coach);
          },
        ),
        GoRoute(
          path: 'book',
          builder: (context, state) {
            final coach = state.extra as FitnessCoach;
            return FitnessBookingScreen(coach: coach);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/pet',
      builder: (context, state) => const PetGroomingScreen(),
      routes: [
         GoRoute(
          path: 'details',
          builder: (context, state) {
            final groomer = state.extra as PetGroomer;
            return PetGroomerDetailScreen(groomer: groomer);
          },
        ),
        GoRoute(
          path: 'book',
          builder: (context, state) {
             final groomer = state.extra as PetGroomer;
            return PetBookingScreen(groomer: groomer);
          },
        ),
      ],
    ),
     GoRoute(
      path: '/cleaning',
      builder: (context, state) =>
      const CleaningScreen(),
      routes: [
         GoRoute(
          path: 'details',
          builder: (context, state) {
            final cleaner = state.extra as Cleaner;
            return CleanerDetailScreen(cleaner: cleaner);
          },
        ),
        GoRoute(
          path: 'book',
          builder: (context, state) {
             final cleaner = state.extra as Cleaner;
            return CleaningBookingScreen(cleaner: cleaner);
          },
        ),
      ],
    ),
     GoRoute(
      path: '/beauty',
      builder: (context, state) => const BeautyScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final provider = state.extra as BeautyProfessional;
            return BeautyDetailScreen(provider: provider);
          },
        ),
         GoRoute(
          path: 'book',
          builder: (context, state) {
            final provider = state.extra as BeautyProfessional;
            return BeautyBookingScreen(provider: provider);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/repairs',
      builder: (context, state) => const RepairsScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final provider = state.extra as RepairProfessional;
            return RepairDetailScreen(provider: provider);
          },
        ),
         GoRoute(
          path: 'book',
          builder: (context, state) {
            final provider = state.extra as RepairProfessional;
            return RepairBookingScreen(provider: provider);
          },
        ),
      ],
    ),

  ],
);
