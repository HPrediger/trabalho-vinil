import 'package:flutter/material.dart';
import '../api/auth_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool carregando = false;
  bool mostrarSenha = false;
  String erro = '';

  // Realiza o login na API
  Future<void> entrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      carregando = true;
      erro = '';
    });

    try {
      await AuthApi.login(
        _emailController.text.trim(),
        _senhaController.text,
      );

      if (!mounted) return;

      // Após autenticar, abre o catálogo
      Navigator.pushReplacementNamed(
        context,
        '/home',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.album,
                  size: 90,
                  color: Colors.blueGrey,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Catálogo de Vinis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // Campo de e-mail
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe o e-mail';
                    }

                    if (!valor.contains('@')) {
                      return 'Informe um e-mail válido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Campo de senha
                TextFormField(
                  controller: _senhaController,
                  obscureText: !mostrarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        mostrarSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          mostrarSenha = !mostrarSenha;
                        });
                      },
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Informe a senha';
                    }

                    if (valor.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                if (erro.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      erro,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                ElevatedButton(
                  onPressed: carregando ? null : entrar,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: carregando
                        ? const CircularProgressIndicator()
                        : const Text('Entrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
