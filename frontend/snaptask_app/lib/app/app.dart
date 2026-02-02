import 'package:flutter/material.dart';
import 'package:snaptask_app/app/router/app_routes.dart';
import 'package:snaptask_app/app/router/app_router.dart';
import 'package:snaptask_app/core/theme/theme.dart';

class SnapTaskApp extends StatefulWidget {
  const SnapTaskApp({super.key});

  @override
  State<SnapTaskApp> createState() => _SnapTaskAppState();
}

class _SnapTaskAppState extends State<SnapTaskApp> {
  ThemeMode _mode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _mode,
      initialRoute: AppRoutes.login,
      onGenerateRoute: (settings) {
        return AppRouter.onGenerateRoute(settings, _toggleTheme);
      },
      onUnknownRoute: AppRouter.onUnknownRoute,
    );
  }
}
