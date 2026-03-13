import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../stores/auth_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Injetando a Store
  late final AuthStore _authStore = GetIt.I.get<AuthStore>();

  // Controladores dos campos de texto
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Chave do formulário para validação simples
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    // Valida se os campos estão preenchidos
    if (!_formKey.currentState!.validate()) return;

    // Remove o teclado da tela
    FocusScope.of(context).unfocus();

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Chama a action do MobX
    final success = await _authStore.login(username, password);

    if (!mounted) return;

    if (success) {
      // Sucesso! Vai para a tela de Feed e remove o Login da pilha (para não voltar com o botão de voltar)
      Navigator.of(context).pushReplacementNamed('/feed');
    } else {
      // Erro! Mostra um SnackBar com a mensagem do Store
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authStore.errorMessage ?? 'Erro ao fazer login'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo ou Título
                  const Icon(Icons.hub, size: 80, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'ESIG Feed',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Faça login para continuar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 48),

                  // Campo de Usuário
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Usuário',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe seu usuário';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo de Senha
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true, // Esconde a senha
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe sua senha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Botão de Login reativo com Observer
                  Observer(
                    builder: (_) {
                      return SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _authStore.isLoading ? null : _doLogin,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _authStore.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text(
                                  'ENTRAR',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}