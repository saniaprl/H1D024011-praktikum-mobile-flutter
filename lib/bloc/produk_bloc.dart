
import 'dart:convert';

import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  // READ - Mengambil Semua Produk
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;

    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    List<dynamic> listProduk = jsonObj['data'] ?? [];

    return listProduk
        .map((produk) => Produk.fromJson(produk))
        .toList();
  }

  // CREATE - Menambahkan Produk
  static Future<bool> addProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.createProduk;

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk,
    };

    var response = await Api().post(apiUrl, body);

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  // UPDATE - Mengubah Produk
  static Future<bool> updateProduk({required Produk produk}) async {
    if (produk.id == null) {
      throw Exception('ID produk tidak ditemukan');
    }

    String apiUrl = ApiUrl.updateProduk(produk.id!);

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk,
    };

    var response = await Api().put(apiUrl, body);

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  // DELETE - Menghapus Produk
  static Future<bool> deleteProduk({required int id}) async {
    String apiUrl = ApiUrl.deleteProduk(id);

    var response = await Api().delete(apiUrl);

    return response.statusCode == 200 ||
        response.statusCode == 204;
  }
}
