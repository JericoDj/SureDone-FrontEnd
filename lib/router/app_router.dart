import 'package:flutter/material.dart';
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
import 'package:suredone/features/placeholder/presentation/placeholder_screen.dart';
import 'package:suredone/features/auth/presentation/login_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: "/home",

  routes: [
    /// LOGIN (NO NAV BAR)
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),

    /// SHELL ROUTE (BOTTOM NAV SHOWS ONLY HERE)
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomePage()),
        GoRoute(path: '/activity', builder: (_, __)  => const ActivityScreen()),
        GoRoute(path: '/messages', builder: (_, __) => const MessagesScreen()),
        GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),

    /// OUTSIDE SHELL → NO BOTTOM NAV
    GoRoute(
      path: '/delivery',
      builder: (context, state) =>
      const PlaceholderScreen(title: "Delivery"),
    ),
    GoRoute(
      path: '/tutor',
      builder: (context, state) =>
      const PlaceholderScreen(title: "Tutor"),
    ),
    GoRoute(
      path: '/fitness',
      builder: (context, state) =>
      const PlaceholderScreen(title: "Fitness"),
    ),
    GoRoute(
      path: '/pet',
      builder: (context, state) =>
      const PlaceholderScreen(title: "Pet Grooming"),
    ),
    GoRoute(
      path: '/dev',
      builder: (context, state) =>
      const PlaceholderScreen(title: "Web/App Development"),
    ),
  ],
);
