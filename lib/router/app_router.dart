import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:suredone/features/auth/presentation/login_screen.dart';


import '../features/home/presentation/home_screen.dart';
import '../features/placeholder/presentation/placeholder_screen.dart';



final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginPage(),
    ),

  //   Pages
    GoRoute(
      path: '/delivery',
      builder: (context, state) => const PlaceholderScreen(title: "Delivery"),
    ),

    GoRoute(
      path: '/tutor',
      builder: (context, state) => const PlaceholderScreen(title: "Tutor"),
    ),

    GoRoute(
      path: '/fitness',
      builder: (context, state) => const PlaceholderScreen(title: "Fitness"),
    ),

    GoRoute(
      path: '/pet',
      builder: (context, state) => const PlaceholderScreen(title: "Pet Grooming"),
    ),

    GoRoute(
      path: '/dev',
      builder: (context, state) => const PlaceholderScreen(title: "Web/App Development"),
    ),
  ],
);
