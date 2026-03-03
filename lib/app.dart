import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/favorite/favorite_screen.dart';

import 'package:flutter_application_1/routes/app_routes.dart';
import 'package:flutter_application_1/features/auth/screens/landing_screen.dart';
import 'package:flutter_application_1/features/auth/screens/login_screen.dart';
import 'package:flutter_application_1/features/auth/screens/signup_screen.dart';
import 'package:flutter_application_1/features/home/home_screen.dart';
import 'package:flutter_application_1/features/auth/screens/edit_profile_screen.dart';
import 'package:flutter_application_1/features/auth/widgets/placeholder_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
        // textTheme: GoogleFonts.notoSansTextTheme(),
      ),
      initialRoute: AppRoutes.landing,
      routes: {
        AppRoutes.landing: (context) => const LandingScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.editProfile: (context) => const EditProfileScreen(),
        AppRoutes.menu: (context) => const PlaceholderScreen(title: "Menu"),
         AppRoutes.favorite: (context) => const FavoriteScreen(),
        // AppRoutes.favorite: (context) =>
        // const PlaceholderScreen(title: "Favorite"),
        AppRoutes.cart: (context) => const PlaceholderScreen(title: "Cart"),
      },
    );
  }
}
