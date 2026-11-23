import 'package:flutter/material.dart';

import '../model/vinil.dart';
import '../tema/cores.dart';

class VinilDetalhesPage extends StatelessWidget {
  final Vinil vinil;

  const VinilDetalhesPage({
    super.key,
    required this.vinil,
  });

  String formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Widget capaPadrao() {
    return Container(
      color: CoresVinil.borda,
      alignment: Alignment.center,
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.album,
            size: 190,
            color: CoresVinil.escuro,
          ),
          CircleAvatar(
            radius: 24,
            backgroundColor: CoresVinil.terracota,
            child: CircleAvatar(
              radius: 7,
              backgroundColor: CoresVinil.fundo,
            ),
          ),
        ],
      ),
    );
  }

  Widget mostrarCapa() {
    final capa = vinil.coverUrl;

    if (capa == null || capa.isEmpty) {
      return capaPadrao();
    }

    return Image.network(
      capa,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return capaPadrao();
      },
    );
  }

  Widget linhaInformacao(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                color: CoresVinil.textoSuave,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: CoresVinil.escuro,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresVinil.fundo,

      appBar: AppBar(
        title: const Text(
          'DETALHES DO DISCO',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: CoresVinil.escuro,
        foregroundColor: CoresVinil.fundo,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Capa do álbum
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 340,
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: mostrarCapa(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Gênero
            Text(
              vinil.genreName.toUpperCase(),
              style: const TextStyle(
                color: CoresVinil.terracota,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 10),

            // Título do disco
            Text(
              vinil.title,
              style: const TextStyle(
                color: CoresVinil.escuro,
                fontSize: 32,
                fontFamily: 'serif',
                height: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            // Artista
            Text(
              vinil.artistName,
              style: const TextStyle(
                color: CoresVinil.textoSuave,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 22),

            // Preço
            Text(
              formatarPreco(vinil.price),
              style: const TextStyle(
                color: CoresVinil.terracota,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Disponibilidade
            Row(
              children: [
                Icon(
                  vinil.stockQuantity > 0
                      ? Icons.check_circle_outline
                      : Icons.remove_circle_outline,
                  size: 18,
                  color: vinil.stockQuantity > 0
                      ? Colors.green.shade700
                      : CoresVinil.terracota,
                ),

                const SizedBox(width: 7),

                Text(
                  vinil.stockQuantity > 0
                      ? 'Disponível em estoque'
                      : 'Indisponível no momento',
                  style: const TextStyle(
                    color: CoresVinil.textoSuave,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Divider(color: CoresVinil.borda),

            const SizedBox(height: 16),

            const Text(
              'Informações do disco',
              style: TextStyle(
                fontFamily: 'serif',
                color: CoresVinil.escuro,
                fontSize: 23,
              ),
            ),

            const SizedBox(height: 12),

            linhaInformacao(
              'Artista',
              vinil.artistName,
            ),

            const Divider(color: CoresVinil.borda),

            linhaInformacao(
              'Gênero',
              vinil.genreName,
            ),

            const Divider(color: CoresVinil.borda),

            linhaInformacao(
              'Ano de lançamento',
              vinil.releaseYear.toString(),
            ),

            const Divider(color: CoresVinil.borda),

            linhaInformacao(
              'Conservação',
              vinil.condition,
            ),

            const Divider(color: CoresVinil.borda),

            linhaInformacao(
              'Rotação',
              '${vinil.rpmSpeed} RPM',
            ),

            const Divider(color: CoresVinil.borda),

            linhaInformacao(
              'Estoque',
              '${vinil.stockQuantity} unidades',
            ),
          ],
        ),
      ),
    );
  }
}
