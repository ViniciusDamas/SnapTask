import 'package:flutter/material.dart';

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
