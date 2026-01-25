import 'package:flutter/material.dart';
import 'package:snaptask_app/app/theme/app_colors.dart';

class AppTextField extends StatefulWidget {
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
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordField = widget.obscureText;

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      style: const TextStyle(color: AppColors.text),
      cursorColor: AppColors.text,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon),
        labelText: widget.label,
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.text,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
