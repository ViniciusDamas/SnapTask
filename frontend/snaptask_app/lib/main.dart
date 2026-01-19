import 'package:flutter/material.dart';
import 'features/auth/ui/login_page.dart';
import 'app/theme/theme.dart';

void main() {
  runApp(const SnapTaskApp());
}

class SnapTaskApp extends StatelessWidget {
  const SnapTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const LoginPage(),
    );
  }
}
