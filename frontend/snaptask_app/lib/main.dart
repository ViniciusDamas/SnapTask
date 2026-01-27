import 'package:flutter/material.dart';
import 'package:snaptask_app/app/routes/app_routes.dart';
import 'package:snaptask_app/app/theme/theme.dart';

void main() {
  runApp(const SnapTaskApp());
}

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _mode,

      initialRoute: AppRoutes.login,

      onGenerateRoute: (settings) {
        final nextMode = _modeForRoute(settings.name);
        if (nextMode != _mode) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() => _mode = nextMode);
          });
        }

        final builder = AppRoutes.routes[settings.name];
        if (builder == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Rota não encontrada')),
            ),
          );
        }

        return MaterialPageRoute(settings: settings, builder: builder);
      },
    );
  }
}
