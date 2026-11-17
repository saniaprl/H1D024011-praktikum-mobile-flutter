import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/login.dart';
import 'api_config.dart';

class LoginService {
  static Future<Login> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 15));

    final json = jsonDecode(response.body);

    if (json is! Map<String, dynamic>) {
      throw const FormatException('Format respons API tidak valid');
    }

    return Login.fromJson(json);
  }
}
