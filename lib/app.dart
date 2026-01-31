import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/screens/landing_screen.dart';
import 'routes/app_routes.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/home/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.landing,
      routes: {
        AppRoutes.landing: (context) => const LandingScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        // AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}
