
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/vinil.dart';

class VinilApi {
  // Endereço da API no emulador Android
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Busca os discos cadastrados
  static Future<List<Vinil>> listarVinis() async {
    final url = Uri.parse('$baseUrl/vinyl-records');

    final resposta = await http.get(url).timeout(
      const Duration(seconds: 15),
    );

    if (resposta.statusCode != 200) {
      throw Exception(
        'Erro ao buscar vinis: ${resposta.statusCode}',
      );
    }

    // Converte o JSON recebido em uma lista
    final dados = jsonDecode(
      utf8.decode(resposta.bodyBytes),
    );

    if (dados is! List) {
      throw Exception('Resposta inesperada da API');
    }

    // Transforma cada elemento da lista em um Vinil
    return dados.map((item) {
      return Vinil.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }
}
