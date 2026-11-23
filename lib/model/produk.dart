
class Produk {
  int? id;
  String? kodeProduk;
  String? namaProduk;
  int? hargaProduk;

  Produk({
    this.id,
    this.kodeProduk,
    this.namaProduk,
    this.hargaProduk,
  });

  // Mengubah data JSON dari API menjadi objek Produk
  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: int.tryParse(obj['id'].toString()),
      kodeProduk: obj['kode_produk']?.toString(),
      namaProduk: obj['nama_produk']?.toString(),
      hargaProduk: int.tryParse(
        obj['harga']?.toString() ?? '',
      ),
    );
  }

  // Mengubah objek Produk menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_produk': kodeProduk,
      'nama_produk': namaProduk,
      'harga': hargaProduk,
    };
  }
}
