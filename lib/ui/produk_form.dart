
import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({super.key, this.produk});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "SIMPAN";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  // Menentukan apakah form untuk tambah atau ubah
  void isUpdate() {
    if (widget.produk != null) {
      judul = "UBAH PRODUK";
      tombolSubmit = "UBAH";

      _kodeProdukTextboxController.text =
          widget.produk!.kodeProduk ?? '';

      _namaProdukTextboxController.text =
          widget.produk!.namaProduk ?? '';

      _hargaProdukTextboxController.text =
          widget.produk!.hargaProduk?.toString() ?? '';
    } else {
      judul = "TAMBAH PRODUK";
      tombolSubmit = "SIMPAN";
    }
  }

  // Membuat objek produk dari input
  Produk _ambilDataForm() {
    return Produk(
      id: widget.produk?.id,
      kodeProduk: _kodeProdukTextboxController.text.trim(),
      namaProduk: _namaProdukTextboxController.text.trim(),
      hargaProduk: int.parse(
        _hargaProdukTextboxController.text.trim(),
      ),
    );
  }

  // ==========================================
  // FUNGSI SIMPAN PRODUK
  // ==========================================

  Future<void> simpan() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final produkBaru = _ambilDataForm();

      final hasil = await ProdukBloc.addProduk(
        produk: produkBaru,
      );

      if (hasil == false) {
        throw Exception('Server menolak penyimpanan produk');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      await _tampilkanError(
        'Simpan gagal, silahkan coba lagi.\n$error',
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
  // FUNGSI UBAH PRODUK
  // ==========================================

  Future<void> ubah() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final produkUpdate = _ambilDataForm();

      final hasil = await ProdukBloc.updateProduk(
        produk: produkUpdate,
      );

      if (hasil == false) {
        throw Exception('Server menolak perubahan produk');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil diubah'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      await _tampilkanError(
        'Ubah produk gagal, silahkan coba lagi.\n$error',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Dialog ketika terjadi kesalahan
  Future<void> _tampilkanError(String pesan) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('GAGAL'),
          content: Text(pesan),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // TEXTBOX KODE PRODUK
  // ==========================================

  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Kode Produk",
      ),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Kode Produk harus diisi";
        }
        return null;
      },
    );
  }

  // ==========================================
  // TEXTBOX NAMA PRODUK
  // ==========================================

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Nama Produk",
      ),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  // ==========================================
  // TEXTBOX HARGA PRODUK
  // ==========================================

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Harga",
      ),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Harga harus diisi";
        }

        final harga = int.tryParse(value.trim());

        if (harga == null || harga < 0) {
          return "Harga harus berupa angka positif";
        }

        return null;
      },
    );
  }

  // ==========================================
  // TOMBOL SIMPAN / UBAH
  // ==========================================

  Widget _buttonSubmit() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isLoading
            ? null
            : () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                if (widget.produk != null) {
                  ubah();
                } else {
                  simpan();
                }
              },
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Text(tombolSubmit),
      ),
    );
  }

  @override
  void dispose() {
    _kodeProdukTextboxController.dispose();
    _namaProdukTextboxController.dispose();
    _hargaProdukTextboxController.dispose();
    super.dispose();
  }

  // ==========================================
  // TAMPILAN FORM PRODUK
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                const SizedBox(height: 12),

                _namaProdukTextField(),
                const SizedBox(height: 12),

                _hargaProdukTextField(),
                const SizedBox(height: 24),

                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
