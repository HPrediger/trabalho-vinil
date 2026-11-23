import 'package:flutter/material.dart';

import '../api/vinil_api.dart';
import '../model/vinil.dart';
import '../tema/cores.dart';
import '../util/token_storage.dart';
import 'vinil_detalhes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _buscaController = TextEditingController();

  List<Vinil> vinis = [];
  String? generoSelecionado;
  String erro = '';
  bool carregando = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    carregarVinis();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _buscaController.dispose();
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      verificarSessao();
    }
  }

  Future<void> verificarSessao() async {
    final valido = await TokenStorage.hasValidToken();

    if (!mounted || valido) return;

    // Token expirado ou ausente: retornar ao login
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

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

        if (generoSelecionado != null &&
            !vinis.any(
              (vinil) => vinil.genreName == generoSelecionado,
            )) {
          generoSelecionado = null;
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = e.toString();
        carregando = false;
      });
    }
  }

  List<String> get generos {
    final resultado = vinis
        .map((vinil) => vinil.genreName)
        .where(
          (nome) => nome.isNotEmpty && nome != 'Não informado',
        )
        .toSet()
        .toList();

    resultado.sort();
    return resultado;
  }

  List<Vinil> get vinisFiltrados {
    final busca = _buscaController.text.trim().toLowerCase();

    return vinis.where((vinil) {
      final correspondePesquisa =
          vinil.title.toLowerCase().contains(busca) ||
          vinil.artistName.toLowerCase().contains(busca);

      final correspondeGenero =
          generoSelecionado == null ||
          vinil.genreName == generoSelecionado;

      return correspondePesquisa && correspondeGenero;
    }).toList();
  }

  Future<void> sair() async {
    try {
      await TokenStorage.deleteToken();

      if (!mounted) return;

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

  String formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Widget mostrarCapa(Vinil vinil) {
    final capa = vinil.coverUrl;

    if (capa != null && capa.isNotEmpty) {
      return Image.network(
        capa,
        fit: BoxFit.cover,
        width: 92,
        height: 92,
        errorBuilder: (context, error, stackTrace) {
          return capaPadrao();
        },
      );
    }

    return capaPadrao();
  }

  Widget capaPadrao() {
    return Container(
      width: 92,
      height: 92,
      color: CoresVinil.borda,
      alignment: Alignment.center,
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.album,
            size: 72,
            color: CoresVinil.escuro,
          ),
          CircleAvatar(
            radius: 9,
            backgroundColor: CoresVinil.terracota,
            child: CircleAvatar(
              radius: 3,
              backgroundColor: CoresVinil.fundo,
            ),
          ),
        ],
      ),
    );
  }

  Widget construirItem(Vinil vinil) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VinilDetalhesPage(
              vinil: vinil,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: mostrarCapa(vinil),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vinil.genreName.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CoresVinil.terracota,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    vinil.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CoresVinil.escuro,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    vinil.artistName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CoresVinil.textoSuave,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    formatarPreco(vinil.price),
                    style: const TextStyle(
                      color: CoresVinil.escuro,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 4),

            const Icon(
              Icons.chevron_right,
              color: CoresVinil.textoSuave,
            ),
          ],
        ),
      ),
    );
  }

  Widget construirConteudo() {
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(
          color: CoresVinil.terracota,
        ),
      );
    }

    if (erro.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 48,
                color: CoresVinil.textoSuave,
              ),
              const SizedBox(height: 14),
              Text(
                erro.replaceFirst('Exception: ', ''),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CoresVinil.textoSuave,
                  fontSize: 14,
                ),
              ),
                            const SizedBox(height: 16),
              OutlinedButton(
                onPressed: carregarVinis,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final lista = vinisFiltrados;

    if (lista.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Nenhum vinil encontrado.\nExperimente outra pesquisa ou gênero.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CoresVinil.textoSuave,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: CoresVinil.terracota,
      onRefresh: carregarVinis,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        itemCount: lista.length,
        separatorBuilder: (context, index) =>
            const Divider(
          height: 20,
          color: CoresVinil.borda,
        ),
        itemBuilder: (context, index) {
          return construirItem(lista[index]);
        },
      ),
    );
  }

  Widget filtroGenero(String? genero, String titulo) {
    final selecionado = generoSelecionado == genero;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(titulo),
        selected: selecionado,
        showCheckmark: false,
        selectedColor: CoresVinil.escuro,
        backgroundColor: CoresVinil.fundo,
        labelStyle: TextStyle(
          color: selecionado
              ? CoresVinil.fundo
              : CoresVinil.escuro,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: selecionado
                ? CoresVinil.escuro
                : CoresVinil.borda,
          ),
        ),
        onSelected: (_) {
          setState(() {
            generoSelecionado = genero;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresVinil.fundo,

      appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: CoresVinil.escuro,
        foregroundColor: CoresVinil.fundo,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VINYL',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 23,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                height: 1,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'S T O R E',
              style: TextStyle(
                color: CoresVinil.coral,
                fontSize: 9,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar catálogo',
            onPressed: carregarVinis,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: sair,
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NOSSA COLEÇÃO',
                  style: TextStyle(
                    color: CoresVinil.terracota,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Explore os vinis',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 32,
                    color: CoresVinil.escuro,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Descubra discos, artistas e clássicos.',
                  style: TextStyle(
                    color: CoresVinil.textoSuave,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 22),

                TextField(
                  controller: _buscaController,
                  onChanged: (valor) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Buscar disco ou artista',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: CoresVinil.terracota,
                    ),
                    suffixIcon: _buscaController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _buscaController.clear();
                              setState(() {});
                            },
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: CoresVinil.borda,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: CoresVinil.terracota,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              children: [
                filtroGenero(null, 'Todos'),
                ...generos.map(
                  (genero) => filtroGenero(genero, genero),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Text(
              carregando
                  ? 'Carregando coleção...'
                  : '${vinisFiltrados.length} discos encontrados',
              style: const TextStyle(
                color: CoresVinil.textoSuave,
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: construirConteudo(),
          ),
        ],
      ),
    );
  }
}
