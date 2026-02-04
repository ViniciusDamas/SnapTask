import 'package:flutter/material.dart';

class SideRailItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final bool selected;
  final bool expanded;
  final bool hovered;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onTap;

  const SideRailItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.expanded,
    required this.hovered,
    required this.onHoverChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final highlight = scheme.primary.withOpacity(0.08);
    final hover = scheme.primary.withOpacity(0.04);
    final bg = selected ? highlight : (hovered ? hover : Colors.transparent);
    final iconColor =
        selected ? scheme.primary : scheme.onSurface.withOpacity(0.7);
    final textColor =
        selected ? scheme.onSurface : scheme.onSurface.withOpacity(0.7);

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: EdgeInsets.symmetric(
              horizontal: expanded ? 12 : 8,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: expanded ? Alignment.centerLeft : Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? (selectedIcon ?? icon) : icon,
                  color: iconColor,
                ),
                if (expanded) ...[
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
