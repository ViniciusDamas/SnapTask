import 'package:flutter/material.dart';
import 'package:snaptask_app/app/routes/app_routes.dart';
import 'package:snaptask_app/app/theme/app_colors.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/core/widgets/app_button.dart';
import 'package:snaptask_app/core/widgets/app_text_field.dart';
import 'package:snaptask_app/core/widgets/auth_header.dart';
import 'package:snaptask_app/features/auth/data/auth_api.dart';
import 'package:snaptask_app/features/auth/data/login_models.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final AuthApi _authApi;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final client = ApiClient(baseUrl: 'http://localhost:8080');

    _authApi = AuthApi(client);
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final req = LoginRequest(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    setState(() => _loading = true);

    try {
      await _authApi.login(req);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso')),
      );

      Navigator.of(context).pushReplacementNamed(AppRoutes.boards);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _goToRegister() {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthHeader(title: 'Bem-vindo de volta!'),
          AppTextField(
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            controller: _emailCtrl,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email é obrigatório';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Email inválido';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Senha',
            icon: Icons.lock_outline,
            obscureText: true,
            controller: _passwordCtrl,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Senha é obrigatória';
              } else if (value.length < 6) {
                return 'A senha deve ter ao menos 6 caracteres';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: AppButton(
              label: 'Entrar',
              loading: _loading,
              onPressed: _submit,
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: _loading ? null : _goToRegister,
            child: const Text('Não tem conta? Registrar-se'),
          ),

          const SizedBox(height: 12),

          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Esqueci minha senha',
                  style: TextStyle(color: AppColors.muted),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
        ],
      ),
    );
  }
}
