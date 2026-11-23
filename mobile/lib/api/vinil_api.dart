import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../model/vinil.dart';

class VinilApi {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static Future<List<Vinil>> listarVinis() async {
    try {
      final url = Uri.parse('$baseUrl/vinyl-records');

      final resposta = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      if (resposta.statusCode != 200) {
        throw Exception(
          'O servidor retornou um erro (${resposta.statusCode}).',
        );
      }

      final dados = jsonDecode(
        utf8.decode(resposta.bodyBytes),
      );

      if (dados is! List) {
        throw const FormatException('Resposta inválida');
      }

      return dados.map((item) {
        return Vinil.fromJson(
          Map<String, dynamic>.from(item),
        );
      }).toList();

    } on SocketException {
      throw Exception(
        'Não foi possível conectar ao servidor. '
        'Verifique se a API está funcionando.',
      );

    } on TimeoutException {
      throw Exception(
        'O servidor demorou muito para responder. '
        'Tente novamente.',
      );

    } on FormatException {
      throw Exception(
        'O servidor retornou dados inválidos.',
      );

    } on http.ClientException {
      throw Exception(
        'Ocorreu um problema na comunicação com a API.',
      );
    }
  }
}
