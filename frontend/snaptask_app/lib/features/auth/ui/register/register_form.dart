import 'package:flutter/material.dart';
import 'package:snaptask_app/core/widgets/app_button.dart';
import 'package:snaptask_app/core/widgets/app_text_field.dart';
import 'package:snaptask_app/core/widgets/auth_header.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _loading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro submit OK (placeholder)')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthHeader(title: 'Crie sua conta'),
          AppTextField(
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            controller: _emailCtrl,
            validator: (v) {
              final value = (v ?? '').trim();
              if (value.isEmpty) return 'Email é obrigatório';
              if (!value.contains('@')) return 'Email inválido';
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Senha',
            icon: Icons.lock_outline,
            obscureText: true,
            controller: _passwordCtrl,
            validator: (v) {
              final value = v ?? '';
              if (value.isEmpty) return 'Senha é obrigatória';
              if (value.length < 6) return 'Mínimo 6 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Confirme a Senha',
            icon: Icons.lock_outline,
            obscureText: true,
            controller: _confirmCtrl,
            validator: (v) {
              final value = v ?? '';
              if (value.isEmpty) return 'Confirme a senha';
              if (value != _passwordCtrl.text) return 'Senhas não conferem';
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: AppButton(
              label: 'Registrar-se',
              loading: _loading,
              onPressed: _submit,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _loading ? null : () => Navigator.of(context).pop(),
            child: const Text('Já tenho conta, voltar para login'),
          ),
        ],
      ),
    );
  }
}
