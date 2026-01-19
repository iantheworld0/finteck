import 'package:fintecks/pages/charges/Charge_Det.dart';
import 'package:fintecks/pages/home/HomeScreen.dart';
import 'package:fintecks/pages/login/LoginScreen.dart';
import 'package:fintecks/pages/onboarding/OnboardingScreen.dart';
import 'package:fintecks/pages/splashpage/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case AppRoutes.charges:
        return MaterialPageRoute(builder: (_) => Charges());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Page non trouvée : ${settings.name}')),
          ),
        );
    }
  }
}
