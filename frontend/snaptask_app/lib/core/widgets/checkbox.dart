import 'package:flutter/material.dart';

class RoundCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;

  const RoundCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkResponse(
      onTap: () => onChanged(!value),
      radius: size,
      customBorder: const CircleBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? scheme.primary : Colors.transparent,
          border: Border.all(
            width: 2,
            color: value ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        child: value
            ? Icon(Icons.check, size: size * 0.65, color: scheme.onPrimary)
            : null,
      ),
    );
  }
}
