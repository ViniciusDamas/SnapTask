import 'package:flutter/material.dart';
import 'package:snaptask_app/features/auth/ui/boards/board_details_page.dart';
import 'package:snaptask_app/features/auth/ui/boards/boards_page.dart';
import 'app_routes.dart';
import '../../features/auth/ui/login/login_page.dart';
import '../../features/auth/ui/register/register_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name;

    if (name != null &&
        name.startsWith(AppRoutes.boardDetailsPrefix) &&
        name.length > AppRoutes.boardDetailsPrefix.length) {
      final boardId = name.substring(AppRoutes.boardDetailsPrefix.length);
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BoardDetailsPage(boardId: boardId),
      );
    }

    switch (name) {
      case AppRoutes.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterPage(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginPage(),
        );
      case AppRoutes.boards:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const BoardsPage(),
        );
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
