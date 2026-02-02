import 'package:flutter/material.dart';
import 'package:snaptask_app/features/cards/ui/card_status.dart';
import 'package:snaptask_app/features/cards/data/cards_models.dart';

class CardWidget extends StatefulWidget {
  final CardSummary card;
  final CardStatus status;
  final VoidCallback onTap;

  const CardWidget({
    super.key,
    required this.card,
    required this.status,
    required this.onTap,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseBorder = scheme.outlineVariant;
    final hoverBorder = isDark
        ? scheme.onSurface.withOpacity(0.35)
        : scheme.onSurface.withOpacity(0.25);
    final borderColor = _hovered ? hoverBorder : baseBorder;
    final borderWidth = _hovered ? 1.5 : 1.0;
    final isDone = widget.status == CardStatus.done;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            child: Opacity(
              opacity: isDone ? 0.8 : 1.0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.card.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isDone)
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: scheme.primary,
                          ),
                      ],
                    ),

                    if (isDone) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: scheme.primary),
                        ),
                        child: Text(
                          'Finalizado',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
