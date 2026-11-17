
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/registrasi.dart';
import 'api_config.dart';

class RegistrasiService {
  static Future<Registrasi> registrasi({
    required String nama,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.registrasi),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 15));

    final json = jsonDecode(response.body);

    if (json is! Map<String, dynamic>) {
      throw const FormatException('Format respons API tidak valid');
    }

    return Registrasi.fromJson(json);
  }
}
