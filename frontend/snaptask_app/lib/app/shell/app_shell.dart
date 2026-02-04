import 'package:flutter/material.dart';
import 'package:snaptask_app/app/router/app_routes.dart';
import 'package:snaptask_app/app/shell/models/navigation_destination_data.dart';
import 'package:snaptask_app/app/shell/widgets/app_nav_drawer.dart';
import 'package:snaptask_app/app/shell/widgets/app_shell_scaffold.dart';
import 'package:snaptask_app/app/shell/widgets/app_top_bar.dart';
import 'package:snaptask_app/app/shell/widgets/navigation_rail_panel.dart';
import 'package:snaptask_app/core/storage/token_storage.dart';
import 'package:snaptask_app/core/widgets/app_search.dart';

class AppShell extends StatefulWidget {
  final Widget body;
  final String title;
  final Widget? titleWidget;
  final VoidCallback onToggleTheme;

  const AppShell({
    super.key,
    required this.body,
    required this.title,
    this.titleWidget,
    required this.onToggleTheme,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final AppSearchController _searchController = AppSearchController();
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  static const _destinations = <NavigationDestinationData>[
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

  void _onSelectDestination(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      case 1:
        showAboutDialog(
          context: context,
          applicationName: 'SnapTask',
          applicationVersion: '1.0.0',
          applicationLegalese: '© 2024 SnapTask Inc.',
        );
    }
  }

  void _logout() {
    TokenStorage.clear();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  void _toggleThemeFromSearch() {
    widget.onToggleTheme();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_searchFocusNode.canRequestFocus) _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rail = NavigationRailPanel(
      destinations: _destinations,
      selectedIndex: _selectedIndex,
      onSelect: _onSelectDestination,
    );
    final drawer = AppNavDrawer(
      title: widget.title,
      destinations: _destinations,
      selectedIndex: _selectedIndex,
      onSelect: _onSelectDestination,
    );
    final appBarTitle = AppTopBar(
      title: widget.title,
      titleWidget: widget.titleWidget,
      isWideLayout: _isWideLayout,
      searchController: _searchController,
      searchTextController: _searchTextController,
      searchFocusNode: _searchFocusNode,
      onToggleTheme: _toggleThemeFromSearch,
      onLogout: _logout,
    );

    return AppSearchScope(
      controller: _searchController,
      child: AppShellScaffold(
        isWideLayout: _isWideLayout,
        appBarTitle: appBarTitle,
        rail: rail,
        drawer: drawer,
        body: widget.body,
      ),
    );
  }
}
