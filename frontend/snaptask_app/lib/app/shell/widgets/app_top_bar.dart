import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snaptask_app/core/widgets/app_search.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final bool isWideLayout;
  final AppSearchController searchController;
  final TextEditingController searchTextController;
  final FocusNode searchFocusNode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const AppTopBar({
    super.key,
    required this.title,
    required this.titleWidget,
    required this.isWideLayout,
    required this.searchController,
    required this.searchTextController,
    required this.searchFocusNode,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            AppLogoSlot(
              title: title,
              titleWidget: titleWidget,
              isWideLayout: isWideLayout,
            ),
            const Spacer(),
            UserMenuButton(onLogout: onLogout),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: AppSearchField(
            searchController: searchController,
            searchTextController: searchTextController,
            searchFocusNode: searchFocusNode,
            onToggleTheme: onToggleTheme,
          ),
        ),
      ],
    );
  }
}

class AppLogoSlot extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final bool isWideLayout;

  const AppLogoSlot({
    super.key,
    required this.title,
    required this.titleWidget,
    required this.isWideLayout,
  });

  @override
  Widget build(BuildContext context) {
    final maxW = isWideLayout ? 260.0 : 190.0;

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
              if (titleWidget != null)
                SizedBox(
                  height: isWideLayout ? 30 : 26,
                  child: titleWidget,
                ),
              if (titleWidget != null) const SizedBox(width: 12),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dongle(
                  fontSize: isWideLayout ? 30 : 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppSearchField extends StatelessWidget {
  final AppSearchController searchController;
  final TextEditingController searchTextController;
  final FocusNode searchFocusNode;
  final VoidCallback onToggleTheme;

  const AppSearchField({
    super.key,
    required this.searchController,
    required this.searchTextController,
    required this.searchFocusNode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final outline = scheme.outline.withValues(alpha: 0.7);
    final hintColor = scheme.onSurface.withValues(alpha: 0.55);
    final iconColor = scheme.onSurface.withValues(alpha: 0.7);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeIcon = isDark
        ? Icons.light_mode_outlined
        : Icons.dark_mode_outlined;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: AnimatedBuilder(
        animation: searchFocusNode,
        builder: (context, _) {
          final borderColor =
              searchFocusNode.hasFocus ? scheme.primary : outline;
          return Container(
            height: 36,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
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
                      controller: searchTextController,
                      focusNode: searchFocusNode,
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
                      onChanged: searchController.setQuery,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: searchController,
                  builder: (context, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (searchController.query.trim().isNotEmpty)
                          IconButton(
                            tooltip: 'Limpar',
                            icon: Icon(Icons.close, size: 18, color: iconColor),
                            onPressed: () {
                              searchController.clear();
                              searchTextController.clear();
                              searchFocusNode.requestFocus();
                            },
                          ),
                        IconButton(
                          tooltip: isDark ? 'Tema claro' : 'Tema escuro',
                          icon: Icon(themeIcon, size: 18, color: iconColor),
                          onPressed: onToggleTheme,
                        ),
                      ],
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
}

enum _UserMenuAction { logout }

class UserMenuButton extends StatelessWidget {
  final VoidCallback onLogout;

  const UserMenuButton({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final border = scheme.outline.withOpacity(0.55);

    return PopupMenuButton<_UserMenuAction>(
      tooltip: 'Conta',
      padding: EdgeInsets.zero,
      splashRadius: 24,
      position: PopupMenuPosition.under,
      color: scheme.surface,
      borderRadius: BorderRadius.circular(999),
      onSelected: (value) {
        if (value == _UserMenuAction.logout) {
          onLogout();
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
        color: scheme.surfaceVariant,
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
}
