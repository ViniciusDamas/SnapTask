import 'package:flutter/material.dart';

class AppShellScaffold extends StatelessWidget {
  final bool isWideLayout;
  final Widget appBarTitle;
  final Widget rail;
  final Widget drawer;
  final Widget body;

  const AppShellScaffold({
    super.key,
    required this.isWideLayout,
    required this.appBarTitle,
    required this.body,
    required this.rail,
    required this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final horizontalPadding = isWideLayout ? 32.0 : 24.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !isWideLayout,
        centerTitle: false,
        toolbarHeight: 64,
        titleSpacing: 16,
        title: appBarTitle,
      ),
      drawer: isWideLayout ? null : drawer,
      body: Row(
        children: [
          if (isWideLayout) rail,
          if (isWideLayout) const VerticalDivider(width: 1),
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
                    child: body,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
