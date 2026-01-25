import 'package:flutter/material.dart';
import 'package:snaptask_app/core/widgets/auth_card.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AuthCard(child: const LoginForm()));
  }
}
