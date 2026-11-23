
import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukDetail extends StatefulWidget {
  final Produk? produk;

  const ProdukDetail({super.key, this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isLoading = false;

  // ==========================================
  // MEMBUKA FORM EDIT PRODUK
  // ==========================================

  Future<void> _editProduk() async {
    if (widget.produk == null || _isLoading) return;

    final hasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ProdukForm(
          produk: widget.produk!,
        ),
      ),
    );

    if (!mounted) return;

    // Kembali ke daftar produk setelah edit berhasil
    // agar data terbaru diambil kembali dari API
    if (hasil == true) {
      Navigator.pop(context, true);
    }
  }

  // ==========================================
  // FUNGSI HAPUS PRODUK
  // ==========================================

  Future<void> _hapusProduk() async {
    final idProduk = widget.produk?.id;

    if (idProduk == null || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final hasil = await ProdukBloc.deleteProduk(
        id: idProduk,
      );

      if (hasil == false) {
        throw Exception('Server menolak penghapusan produk');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('GAGAL'),
            content: Text(
              'Hapus produk gagal.\n$error',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================
  // KONFIRMASI HAPUS
  // ==========================================

  Future<void> confirmHapus() async {
    if (_isLoading) return;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: const Text(
            "Yakin ingin menghapus data ini?",
          ),
          actions: [
            // Tombol Ya
            OutlinedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("Ya"),
            ),

            // Tombol Batal
            OutlinedButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Batal"),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (konfirmasi == true) {
      await _hapusProduk();
    }
  }

  // ==========================================
  // TOMBOL EDIT DAN DELETE
  // ==========================================

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          onPressed: _isLoading ? null : _editProduk,
          child: const Text("EDIT"),
        ),

        const SizedBox(width: 12),

        // Tombol Delete
        OutlinedButton(
          onPressed: _isLoading ? null : confirmHapus,
          child: const Text("DELETE"),
        ),
      ],
    );
  }

  // ==========================================
  // TAMPILAN DETAIL PRODUK
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: produk == null
          ? const Center(
              child: Text('Data produk tidak tersedia'),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Kode : ${produk.kodeProduk}",
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Nama : ${produk.namaProduk}",
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Harga : Rp. ${produk.hargaProduk}",
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    _tombolHapusEdit(),
                ],
              ),
            ),
    );
  }
}
