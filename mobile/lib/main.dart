import 'package:flutter/material.dart';

import 'telas/login.dart';
import 'telas/home.dart';
import 'util/token_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo de Vinis',

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const TelaInicial(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

// Verifica a autenticação ao iniciar o aplicativo
class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  late Future<bool> autenticado;

  @override
  void initState() {
    super.initState();

    autenticado = TokenStorage.hasValidToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: autenticado,
      builder: (context, snapshot) {

        // Enquanto verifica o token
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Token existente e não expirado
        if (snapshot.data == true) {
          return const HomePage();
        }

        // Sem token válido: mostrar login
        return const LoginPage();
      },
    );
  }
}
