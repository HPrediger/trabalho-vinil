import 'package:flutter/material.dart';
import '../model/vinil.dart';

class VinilDetalhesPage extends StatelessWidget {
  final Vinil vinil;

  const VinilDetalhesPage({
    super.key,
    required this.vinil,
  });

  @override
  Widget build(BuildContext context) {
    final capa = vinil.coverUrl ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Vinil'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: capa.isNotEmpty
                  ? Image.network(
                      capa,
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.album,
                          size: 150,
                        );
                      },
                    )
                  : const Icon(
                      Icons.album,
                      size: 150,
                    ),
            ),

            const SizedBox(height: 25),

            Text(
              vinil.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text('Artista: ${vinil.artistName}'),
            Text('Gênero: ${vinil.genreName}'),
            Text('Ano: ${vinil.releaseYear}'),
            Text('Conservação: ${vinil.condition}'),
            Text('Rotação: ${vinil.rpmSpeed} RPM'),
            Text('Estoque: ${vinil.stockQuantity} unidades'),

            const SizedBox(height: 25),

            Text(
              'R\$ ${vinil.price.toStringAsFixed(2).replaceAll('.', ',')}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
