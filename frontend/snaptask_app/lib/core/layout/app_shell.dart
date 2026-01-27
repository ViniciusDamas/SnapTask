import 'package:flutter/material.dart';
import 'package:snaptask_app/app/routes/app_routes.dart';
import 'package:snaptask_app/core/auth/token_storage.dart';

class AppShell extends StatefulWidget {
  final Widget body;
  final String title;
  final Widget? titleWidget;

  const AppShell({
    super.key,
    required this.body,
    required this.title,
    this.titleWidget,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  bool _expanded = true;

  final _destinations = const <NavigationDestinationData>[
    NavigationDestinationData(
      label: 'Boards',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
    ),
    NavigationDestinationData(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
    ),
  ];

  bool get _isWideLayout => MediaQuery.sizeOf(context).width >= 900;

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _onSelect(int index) {
    setState(() => _selectedIndex = index);
    _showSnack('Selecionado: ${_destinations[index].label}');
  }

  void _logout() {
    TokenStorage.clear();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: _logout,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logout),
            if (_expanded) ...[const SizedBox(width: 12), const Text('Logout')],
          ],
        ),
      ),
    );
  }

  Widget _buildRail() {
    return NavigationRail(
      extended: _expanded,
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onSelect,
      leading: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: IconButton(
          tooltip: _expanded ? 'Recolher menu' : 'Expandir menu',
          icon: Icon(_expanded ? Icons.chevron_left : Icons.chevron_right),
          onPressed: () => setState(() => _expanded = !_expanded),
        ),
      ),
      destinations: _destinations
          .map(
            (d) => NavigationRailDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: Text(d.label),
            ),
          )
          .toList(),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: _buildLogoutButton(),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(),

            for (int i = 0; i < _destinations.length; i++)
              ListTile(
                leading: Icon(
                  i == _selectedIndex
                      ? _destinations[i].selectedIcon
                      : _destinations[i].icon,
                ),
                title: Text(_destinations[i].label),
                selected: i == _selectedIndex,
                onTap: () {
                  Navigator.of(context).pop();
                  _onSelect(i);
                },
              ),

            const Spacer(),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rail = _buildRail();
    final drawer = _buildDrawer();

    return Scaffold(
      appBar: AppBar(
        title: widget.titleWidget ?? Text(widget.title),
        automaticallyImplyLeading: !_isWideLayout,
      ),
      drawer: _isWideLayout ? null : drawer,
      body: Row(
        children: [
          if (_isWideLayout) rail,
          if (_isWideLayout) const VerticalDivider(width: 1),
          Expanded(child: widget.body),
        ],
      ),
    );
  }
}

class NavigationDestinationData {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const NavigationDestinationData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}
