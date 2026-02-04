import 'package:flutter/material.dart';
import 'package:snaptask_app/app/shell/models/navigation_destination_data.dart';
import 'package:snaptask_app/app/shell/widgets/side_rail_item.dart';

class NavigationRailPanel extends StatefulWidget {
  final List<NavigationDestinationData> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const NavigationRailPanel({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<NavigationRailPanel> createState() => _NavigationRailPanelState();
}

class _NavigationRailPanelState extends State<NavigationRailPanel> {
  bool _expanded = true;
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = _expanded ? 240.0 : 72.0;

    return Container(
      width: width,
      color: scheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Align(
            alignment: _expanded ? Alignment.centerRight : Alignment.center,
            child: IconButton(
              tooltip: _expanded ? 'Recolher menu' : 'Expandir menu',
              icon: Icon(_expanded ? Icons.chevron_left : Icons.chevron_right),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (int i = 0; i < widget.destinations.length; i++)
                  SideRailItem(
                    label: widget.destinations[i].label,
                    icon: widget.destinations[i].icon,
                    selectedIcon: widget.destinations[i].selectedIcon,
                    selected: i == widget.selectedIndex,
                    expanded: _expanded,
                    hovered: _hoveredIndex == i,
                    onHoverChanged: (hovered) {
                      setState(() => _hoveredIndex = hovered ? i : null);
                    },
                    onTap: () => widget.onSelect(i),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
