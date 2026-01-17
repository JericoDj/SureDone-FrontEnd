import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suredone/router/app_router.dart';


// Blocs
import 'core/theme/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
      ],
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.lightTheme,
        title: 'SureDone',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter, // ← moved router here
      ),
    );
  }
}
