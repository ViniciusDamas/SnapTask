import 'package:flutter/material.dart';
import 'package:snaptask_app/features/auth/ui/login/login_page.dart';
import 'package:snaptask_app/features/auth/ui/register/register_page.dart';
import 'package:snaptask_app/features/auth/ui/boards/boards_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const boards = '/boards';
  static const boardDetailsPrefix = '/boards/';

  static String boardDetails(String id) => '$boardDetailsPrefix$id';

  static final routes = <String, WidgetBuilder>{
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    boards: (_) => const BoardsPage(),
  };
}
