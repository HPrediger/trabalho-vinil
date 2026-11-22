import 'dart:convert';

import 'package:http/http.dart' as http;
import '../util/token_storage.dart';

class AuthApi {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static Future<void> login(
    String email,
    String senha,
  ) async {
    final url = Uri.parse('$baseUrl/auth/login');

    // Envia os dados para a API
    final resposta = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': senha,
      }),
    ).timeout(const Duration(seconds: 15));

    if (resposta.statusCode == 200 ||
        resposta.statusCode == 201) {
      final dados = jsonDecode(
        utf8.decode(resposta.bodyBytes),
      );

      // O backend retorna o token em access_token
      final token = dados['access_token'];

      if (token == null || token is! String) {
        throw Exception('Token não recebido da API.');
      }

      // Salva o token no dispositivo
      await TokenStorage.saveToken(token);
    } else if (resposta.statusCode == 401) {
      throw Exception('E-mail ou senha inválidos.');
    } else {
      throw Exception(
        'Erro ao realizar login: ${resposta.statusCode}',
      );
    }
  }
}
