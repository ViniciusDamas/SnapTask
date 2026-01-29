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
  ThemeMode _mode = ThemeMode.light;

  ThemeMode _modeForRoute(String? routeName) {
    if (routeName == AppRoutes.login || routeName == AppRoutes.register) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  void _syncThemeMode(String? routeName) {
    final nextMode = _modeForRoute(routeName);
    if (nextMode == _mode) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _mode = nextMode);
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
        _syncThemeMode(settings.name);
        return AppRouter.onGenerateRoute(settings);
      },
      onUnknownRoute: AppRouter.onUnknownRoute,
    );
  }
}
