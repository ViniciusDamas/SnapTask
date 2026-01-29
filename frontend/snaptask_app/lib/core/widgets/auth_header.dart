import 'package:flutter/material.dart';
import 'package:snaptask_app/core/theme/app_colors.dart';

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
    final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: AppColors.text,
      fontWeight: FontWeight.bold,
    );

    final subtitleStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogo) ...[
          const Image(
            image: AssetImage('assets/images/logo_mini_light.png'),
            height: 40,
          ),
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
