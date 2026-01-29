import 'package:flutter/material.dart';
class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border(
            top: BorderSide(color: scheme.outline, width: 2),
          ),
        ),
        child: child,
      ),
    );
  }
}
