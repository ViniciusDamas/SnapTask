import 'package:flutter/material.dart';
import 'package:snaptask_app/app/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(color: AppColors.text),
      cursorColor: AppColors.text,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(prefixIcon: Icon(icon), labelText: label),
    );
  }
}
