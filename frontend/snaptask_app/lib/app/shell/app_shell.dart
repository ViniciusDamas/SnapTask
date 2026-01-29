import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snaptask_app/app/router/app_routes.dart';
import 'package:snaptask_app/core/storage/token_storage.dart';
import 'package:snaptask_app/core/widgets/app_search.dart';

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

enum _UserMenuAction { logout }

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  bool _expanded = true;
  int? _hoveredIndex;

  final AppSearchController _search = AppSearchController();
  final TextEditingController _searchText = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

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

  @override
  void dispose() {
    _search.dispose();
    _searchText.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Widget _buildSearchBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final outline = scheme.outline.withOpacity(0.45);
    final hintColor = scheme.onSurface.withOpacity(0.55);
    final iconColor = scheme.onSurface.withOpacity(0.7);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: AnimatedBuilder(
        animation: _searchFocus,
        builder: (context, _) {
          final borderColor = _searchFocus.hasFocus ? scheme.primary : outline;
          return Container(
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: borderColor),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.search, size: 18, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      inputDecorationTheme: const InputDecorationTheme(
                        filled: false,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    child: TextField(
                      controller: _searchText,
                      focusNode: _searchFocus,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: hintColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: _search.setQuery,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _search,
                  builder: (context, _) {
                    if (_search.query.trim().isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      tooltip: 'Limpar',
                      icon: Icon(Icons.close, size: 18, color: iconColor),
                      onPressed: () {
                        _search.clear();
                        _searchText.clear();
                        _searchFocus.requestFocus();
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoSlot() {
    final maxW = _isWideLayout ? 260.0 : 190.0;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxW),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.titleWidget != null)
                SizedBox(
                  height: _isWideLayout ? 30 : 26,
                  child: widget.titleWidget,
                ),
              if (widget.titleWidget != null) const SizedBox(width: 12),
              Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dongle(
                  fontSize: _isWideLayout ? 30 : 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserMenu(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final border = scheme.outline.withOpacity(0.55);

    return PopupMenuButton<_UserMenuAction>(
      tooltip: 'Conta',
      padding: EdgeInsets.zero,
      splashRadius: 24,
      borderRadius: BorderRadius.circular(999),
      onSelected: (value) {
        if (value == _UserMenuAction.logout) {
          _logout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _UserMenuAction.logout,
          child: Row(
            children: [
              Icon(Icons.logout, size: 18, color: scheme.onSurface),
              const SizedBox(width: 8),
              const Text('Logout'),
            ],
          ),
        ),
      ],
      child: Material(
        color: scheme.surface,
        shape: CircleBorder(side: BorderSide(color: border)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: scheme.primary.withOpacity(0.12),
            child: Icon(Icons.person, size: 18, color: scheme.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [_buildLogoSlot(), const Spacer(), _buildUserMenu(context)],
        ),
        Align(alignment: Alignment.center, child: _buildSearchBar(context)),
      ],
    );
  }

  Widget _buildRailItem({
    required int index,
    required String label,
    required IconData icon,
    IconData? selectedIcon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final hovered = _hoveredIndex == index;
    final highlight = scheme.primary.withOpacity(0.08);
    final hover = scheme.primary.withOpacity(0.04);
    final bg = selected ? highlight : (hovered ? hover : Colors.transparent);
    final iconColor = selected
        ? scheme.primary
        : scheme.onSurface.withOpacity(0.7);
    final textColor = selected
        ? scheme.onSurface
        : scheme.onSurface.withOpacity(0.7);

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
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
              horizontal: _expanded ? 12 : 8,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: _expanded ? Alignment.centerLeft : Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? (selectedIcon ?? icon) : icon,
                  color: iconColor,
                ),
                if (_expanded) ...[
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

  Widget _buildRail() {
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
                for (int i = 0; i < _destinations.length; i++)
                  _buildRailItem(
                    index: i,
                    label: _destinations[i].label,
                    icon: _destinations[i].icon,
                    selectedIcon: _destinations[i].selectedIcon,
                    selected: i == _selectedIndex,
                    onTap: () => _onSelect(i),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rail = _buildRail();
    final drawer = _buildDrawer();
    final horizontalPadding = _isWideLayout ? 32.0 : 24.0;

    return AppSearchScope(
      controller: _search,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !_isWideLayout,
          centerTitle: false,
          toolbarHeight: 64,
          titleSpacing: 16,
          title: _buildAppBarTitle(context),
        ),
        drawer: _isWideLayout ? null : drawer,
        body: Row(
          children: [
            if (_isWideLayout) rail,
            if (_isWideLayout) const VerticalDivider(width: 1),
            Expanded(
              child: Container(
                color: scheme.surface,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        24,
                        horizontalPadding,
                        24,
                      ),
                      child: widget.body,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
