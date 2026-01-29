import 'package:flutter/material.dart';
import 'package:snaptask_app/app/router/app_routes.dart';
import 'package:snaptask_app/core/config/env.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/core/http/exceptions/api_exception.dart';
import 'package:snaptask_app/core/storage/token_storage.dart';
import 'package:snaptask_app/core/theme/app_colors.dart';
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
  String? _emailApiError;
  String? _passwordApiError;

  @override
  void initState() {
    super.initState();

    final client = ApiClient(baseUrl: Env.baseUrl);
    _authApi = AuthApi(client);
    _emailCtrl.addListener(() {
      if (_emailApiError != null) {
        setState(() => _emailApiError = null);
        _formKey.currentState?.validate();
      }
    });

    _passwordCtrl.addListener(() {
      if (_passwordApiError != null) {
        setState(() => _passwordApiError = null);
        _formKey.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      _emailApiError = null;
      _passwordApiError = null;
      _loading = true;
    });

    final req = LoginRequest(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    try {
      final res = await _authApi.login(req);

      TokenStorage.save(res.token);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso')),
      );

      Navigator.of(context).pushReplacementNamed(AppRoutes.boards);
    } on ApiException catch (e) {
      if (!mounted) return;

      final status = e.statusCode;
      final problem = e.problem;

      if (status == 400 && problem?.errors != null) {
        final errors = problem!.errors!;
        final emailMsgs = errors['Email'] ?? errors['email'];
        final passMsgs = errors['Password'] ?? errors['password'];

        setState(() {
          _emailApiError = (emailMsgs != null && emailMsgs.isNotEmpty)
              ? emailMsgs.first
              : null;
          _passwordApiError = (passMsgs != null && passMsgs.isNotEmpty)
              ? passMsgs.first
              : null;
        });

        _formKey.currentState?.validate();
        return;
      }

      if (status == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email ou senha incorretos')),
        );
        return;
      }
      if (status == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você não tem permissão para acessar')),
        );
        return;
      }

      debugPrint(e.toDebugString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(problem?.userMessage ?? 'Falha ao realizar login'),
        ),
      );
    } catch (e) {
      debugPrint('Erro inesperado no login: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado. Tente novamente.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
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
              if (_emailApiError != null) return _emailApiError;
              if (value == null || value.isEmpty) return 'Email é obrigatório';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Email inválido';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          AppTextField(
            label: 'Senha',
            icon: Icons.lock_outline,
            obscureText: true,
            controller: _passwordCtrl,
            validator: (value) {
              if (_passwordApiError != null) return _passwordApiError;

              if (value == null || value.isEmpty) return 'Senha é obrigatória';
              if (value.length < 6) {
                return 'A senha deve ter ao menos 6 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: AppButton(
              label: 'Entrar',
              loading: _loading,
              onPressed: _loading ? null : _submit,
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
