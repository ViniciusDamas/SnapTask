import 'package:flutter/material.dart';
import 'package:snaptask_app/core/theme/app_colors.dart';

class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: const Border(
            top: BorderSide(color: Color(0xFF2A2A2A), width: 2),
          ),
        ),
        child: child,
      ),
    );
  }
}
