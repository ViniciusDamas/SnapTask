import 'package:flutter/material.dart';
import 'package:snaptask_app/app/shell/models/navigation_destination_data.dart';

class AppNavDrawer extends StatelessWidget {
  final String title;
  final List<NavigationDestinationData> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const AppNavDrawer({
    super.key,
    required this.title,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: scheme.background,
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(),
            for (int i = 0; i < destinations.length; i++)
              ListTile(
                leading: Icon(
                  i == selectedIndex
                      ? destinations[i].selectedIcon
                      : destinations[i].icon,
                ),
                title: Text(destinations[i].label),
                selected: i == selectedIndex,
                onTap: () {
                  Navigator.of(context).pop();
                  onSelect(i);
                },
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
