
import 'package:flutter/material.dart';

import '../api/vinil_api.dart';
import '../model/vinil.dart';
import 'vinil_detalhes.dart';
import '../util/token_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Vinil> vinis = [];

  bool carregando = true;
  String erro = '';

  @override
  void initState() {
    super.initState();
    carregarVinis();
  }

  Future<void> sair() async {
    try {
      // Remove o token salvo
      await TokenStorage.deleteToken();

      if (!mounted) return;

      // Retorna ao login, removendo as telas anteriores
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível sair da conta.'),
        ),
      );
    }
  }

  // Busca os vinis utilizando nosso serviço da API
  Future<void> carregarVinis() async {
    setState(() {
      carregando = true;
      erro = '';
    });

    try {
      final resultado = await VinilApi.listarVinis();

      if (!mounted) return;

      setState(() {
        vinis = resultado;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = e.toString();
        carregando = false;
      });
    }
  }

  // Exibe a capa ou um ícone caso não exista imagem
  Widget mostrarCapa(Vinil vinil) {
    final capa = vinil.coverUrl;

    if (capa == null || capa.isEmpty) {
      return const Icon(Icons.album, size: 45);
    }

    return Image.network(
      capa,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.album, size: 45);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Vinis'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: carregarVinis,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: sair,
          ),
        ],
      ),
      body: carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : erro.isNotEmpty
              ? Center(
                  child: Text(erro),
                )
              : vinis.isEmpty
                  ? const Center(
                      child: Text('Nenhum vinil cadastrado.'),
                    )
                  : ListView.builder(
                      itemCount: vinis.length,
                      itemBuilder: (context, index) {
                        final vinil = vinis[index];

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: mostrarCapa(vinil),
                            title: Text(vinil.title),
                            subtitle: Text(
                              '${vinil.artistName}\n'
                              'Ano: ${vinil.releaseYear}',
                            ),
                            isThreeLine: true,
                            trailing: const Icon(
                              Icons.chevron_right,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VinilDetalhesPage(
                                    vinil: vinil,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
