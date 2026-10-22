
import 'package:flutter/material.dart';

import 'models/tour_package.dart';
import 'routes/app_routes.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/not_found_screen.dart';

void main() {
  runApp(const NusaTravelApp());
}

class NusaTravelApp extends StatelessWidget {
  const NusaTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaTravel',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.home: (_) => HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.detail) {
          final argument = settings.arguments;

          if (argument is TourPackage) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => DetailScreen(tour: argument),
            );
          }

          return MaterialPageRoute(
            builder: (_) => const NotFoundScreen(),
          );
        }

        if (settings.name == AppRoutes.booking) {
          final argument = settings.arguments;

          if (argument is TourPackage) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => BookingScreen(tour: argument),
            );
          }

          return MaterialPageRoute(
            builder: (_) => const NotFoundScreen(),
          );
        }

        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NotFoundScreen(),
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087E8B),
        ),
        useMaterial3: true,
      ),
    );
  }
}
