
import 'package:flutter/material.dart';
import 'package:tokokita/bloc/logout_bloc.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Produk>> _futureProduk;

  @override
  void initState() {
    super.initState();
    _loadProduk();
  }

  // Mengambil daftar produk dari REST API
  void _loadProduk() {
    _futureProduk = ProdukBloc.getProduks();
  }

  // Memperbarui daftar produk
  void _refreshProduk() {
    setState(() {
      _loadProduk();
    });
  }

  // Membuka form tambah produk
  Future<void> _tambahProduk() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProdukForm(),
      ),
    );

    if (!mounted) return;
    _refreshProduk();
  }

  // Proses logout
  Future<void> _logout() async {
    try {
      await LogoutBloc.logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout gagal: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: _tambahProduk,
              child: const Icon(
                Icons.add,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),

      // Menu Logout
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: _logout,
            ),
          ],
        ),
      ),

      // Menampilkan produk dari REST API
      body: FutureBuilder<List<Produk>>(
        future: _futureProduk,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Gagal mengambil data produk',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshProduk,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final daftarProduk = snapshot.data ?? [];

          if (daftarProduk.isEmpty) {
            return const Center(
              child: Text('Belum ada data produk'),
            );
          }

          return ListProduk(
            list: daftarProduk,
            onRefresh: _refreshProduk,
          );
        },
      ),
    );
  }
}

// ==========================================
// LIST PRODUK
// ==========================================

class ListProduk extends StatelessWidget {
  final List<Produk> list;
  final VoidCallback onRefresh;

  const ListProduk({
    super.key,
    required this.list,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ItemProduk(
          produk: list[index],
          onRefresh: onRefresh,
        );
      },
    );
  }
}

// ==========================================
// ITEM PRODUK
// ==========================================

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback onRefresh;

  const ItemProduk({
    super.key,
    required this.produk,
    required this.onRefresh,
  });

  Future<void> _bukaDetail(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdukDetail(
          produk: produk,
        ),
      ),
    );

    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _bukaDetail(context),
      child: Card(
        child: ListTile(
          title: Text(
            produk.namaProduk ?? '',
          ),
          subtitle: Text(
            'Rp ${produk.hargaProduk}',
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
        ),
      ),
    );
  }
}
