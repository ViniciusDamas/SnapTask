import 'package:flutter/material.dart';
import 'package:snaptask_app/core/widgets/auth_card.dart';
import 'register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AuthCard(child: const RegisterForm()));
  }
}
