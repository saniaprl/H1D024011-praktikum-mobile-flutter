
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'user_info.dart';
import 'app_exception.dart';

class Api {
  // POST - Registrasi, Login, Tambah Produk
  Future<dynamic> post(dynamic url, dynamic data) async {
    final String? token = await UserInfo().getToken();

    try {
      final response = await http.post(
        Uri.parse(url.toString()),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          if (token != null && token.isNotEmpty)
            HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // GET - Mengambil Data Produk
  Future<dynamic> get(dynamic url) async {
    final String? token = await UserInfo().getToken();

    try {
      final response = await http.get(
        Uri.parse(url.toString()),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          if (token != null && token.isNotEmpty)
            HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // PUT - Mengubah Data Produk
  Future<dynamic> put(dynamic url, dynamic data) async {
    final String? token = await UserInfo().getToken();

    try {
      final response = await http.put(
        Uri.parse(url.toString()),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          if (token != null && token.isNotEmpty)
            HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // DELETE - Menghapus Produk
  Future<dynamic> delete(dynamic url) async {
    final String? token = await UserInfo().getToken();

    try {
      final response = await http.delete(
        Uri.parse(url.toString()),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          if (token != null && token.isNotEmpty)
            HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // Penanganan Response API
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;

      case 400:
        throw BadRequestException(response.body);

      case 401:
      case 403:
        throw UnauthorisedException(response.body);

      case 422:
        throw InvalidInputException(response.body);

      case 500:
      default:
        throw FetchDataException(
          'Error saat komunikasi dengan server. '
          'StatusCode: ${response.statusCode}. '
          'Response: ${response.body}',
        );
    }
  }
}
