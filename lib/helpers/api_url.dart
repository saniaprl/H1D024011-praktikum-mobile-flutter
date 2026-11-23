
class ApiUrl {
  static const String baseUrl = 'http://10.189.17.238:8080';

  // Registrasi dan Login
  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';

  // Produk
  static const String listProduk = '$baseUrl/produk';
  static const String createProduk = '$baseUrl/produk';

  // Update Produk
  static String updateProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  // Detail Produk
  static String showProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  // Hapus Produk
  static String deleteProduk(int id) {
    return '$baseUrl/produk/$id';
  }
}
