import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.onFieldSubmitted,
    this.textInputAction,
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
    final scheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      style: TextStyle(color: scheme.onSurface),
      cursorColor: scheme.onSurface,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon),
        labelText: widget.label,
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: scheme.onSurface.withOpacity(0.7),
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
