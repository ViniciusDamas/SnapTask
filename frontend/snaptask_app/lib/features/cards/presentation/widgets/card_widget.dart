import 'package:flutter/material.dart';
import 'package:snaptask_app/features/cards/data/cards_models.dart';
import 'package:snaptask_app/features/cards/presentation/widgets/card_status.dart';
import 'package:snaptask_app/core/widgets/checkbox.dart';

class CardWidget extends StatefulWidget {
  final CardSummary card;
  final VoidCallback onTap;
  final Future<void> Function(CardStatus nextStatus) onToggleStatus;

  const CardWidget({
    super.key,
    required this.card,
    required this.onTap,
    required this.onToggleStatus,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _isHovered = false;
  bool _saving = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
  }

  bool get _isDone => widget.card.status == CardStatus.done;

  Future<void> _toggleDone() async {
    if (_saving) return;

    final next = _isDone ? CardStatus.open : CardStatus.done;

    setState(() => _saving = true);
    try {
      await widget.onToggleStatus(next);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final baseBorder = scheme.outlineVariant;
    final hoverBorder = scheme.onSurface;
    final borderColor = _isHovered ? hoverBorder : baseBorder;
    final borderWidth = _isHovered ? 1.5 : 1.0;

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
              opacity: _isDone ? 0.8 : 1.0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 120),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.horizontal,
                            child: child,
                          ),
                        );
                      },
                      child: (_isHovered || _isDone)
                          ? Padding(
                              key: const ValueKey('checkbox'),
                              padding: const EdgeInsets.only(right: 8),
                              child: IgnorePointer(
                                ignoring: _saving,
                                child: RoundCheckbox(
                                  value: _isDone,
                                  onChanged: (_) => _toggleDone(),
                                  size: 18,
                                ),
                              ),
                            )
                          : const SizedBox(key: ValueKey('spacer'), width: 26),
                    ),
                    Expanded(
                      child: Text(
                        widget.card.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: _isDone
                              ? TextDecoration.lineThrough
                              : null,
                          color: _isDone
                              ? scheme.onSurfaceVariant
                              : scheme.onSurface,
                        ),
                      ),
                    ),
                    if (_saving) ...[
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
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
