import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showLogo;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final logoAsset = 'assets/images/logo_mini_light.png';
    final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: scheme.onSurface,
      fontWeight: FontWeight.bold,
    );

    final subtitleStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withOpacity(0.7));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogo) ...[
          Image(image: AssetImage(logoAsset), height: 40),
          const SizedBox(height: 24),
        ],
        Text(title, style: titleStyle),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: subtitleStyle, textAlign: TextAlign.center),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}
