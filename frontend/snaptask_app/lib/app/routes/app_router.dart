import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../features/auth/ui/login/login_page.dart';
import '../../features/auth/ui/register/register_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name;

    switch (name) {
      case AppRoutes.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterPage(),
        );

      case AppRoutes.login:
      case '/':
      case null:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginPage(),
        );

      default:
        return onUnknownRoute(settings);
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const LoginPage(),
    );
  }
}
