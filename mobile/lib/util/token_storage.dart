import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';

  // Salvar token
  static Future<void> saveToken(String token) async {
    await _storage.write(
      key: _keyToken,
      value: token,
    );
  }

  // Recuperar token
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Excluir token
  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // Verificar se existe um token que ainda não expirou
  static Future<bool> hasValidToken() async {
    try {
      final token = await getToken();

      if (token == null || token.isEmpty) {
        return false;
      }

      // Separa as partes do JWT
      final partes = token.split('.');

      if (partes.length != 3) {
        await deleteToken();
        return false;
      }

      // Lê as informações do token
      final payload = utf8.decode(
        base64Url.decode(
          base64Url.normalize(partes[1]),
        ),
      );

      final dados = jsonDecode(payload);

      // Verifica a data de expiração
      final expiracao = dados['exp'];

      if (expiracao is! num) {
        await deleteToken();
        return false;
      }

      final agora =
          DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (agora >= expiracao.toInt()) {
        await deleteToken();
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
