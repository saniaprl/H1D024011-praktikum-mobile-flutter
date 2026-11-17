import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/api_config.dart';

class TestApiPage extends StatefulWidget {
  const TestApiPage({super.key});

  @override
  State<TestApiPage> createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  String hasil = 'Belum melakukan pengujian';

  Future<void> testKoneksi() async {
    setState(() {
      hasil = 'Menghubungkan ke API CodeIgniter...';
    });

    try {
      final response = await http
          .get(Uri.parse(ApiConfig.produk))
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      final data = jsonDecode(response.body);

      setState(() {
        hasil = 'HTTP ${response.statusCode}\n\n'
            '${const JsonEncoder.withIndent('  ').convert(data)}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        hasil = 'Koneksi gagal:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tes API CodeIgniter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: testKoneksi,
              child: const Text('Tes Koneksi API'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(hasil),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
