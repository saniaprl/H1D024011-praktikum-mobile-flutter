
import 'package:flutter/material.dart';
import '../services/registrasi_service.dart';
import 'login_page.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();

  // Proses registrasi ke API CodeIgniter
  Future<void> _prosesRegistrasi() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final hasil = await RegistrasiService.registrasi(
        nama: _namaTextboxController.text.trim(),
        email: _emailTextboxController.text.trim(),
        password: _passwordTextboxController.text,
      );

      if (!mounted) return;

      if (hasil.status == true && hasil.code == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(hasil.data ?? 'Registrasi gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghubungi server: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Textbox Nama
  Widget _namaTextField() {
    return TextFormField(
      controller: _namaTextboxController,
      decoration: const InputDecoration(
        labelText: 'Nama',
      ),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.trim().length < 3) {
          return 'Nama harus diisi minimal 3 karakter';
        }
        return null;
      },
    );
  }

  // Textbox Email
  Widget _emailTextField() {
    return TextFormField(
      controller: _emailTextboxController,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email harus diisi';
        }

        final pattern = RegExp(
          r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
        );

        if (!pattern.hasMatch(value.trim())) {
          return 'Email tidak valid';
        }

        return null;
      },
    );
  }

  // Textbox Password
  Widget _passwordTextField() {
    return TextFormField(
      controller: _passwordTextboxController,
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Password harus diisi minimal 6 karakter';
        }
        return null;
      },
    );
  }

  // Textbox Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      controller: _konfirmasiPasswordController,
      decoration: const InputDecoration(
        labelText: 'Konfirmasi Password',
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Konfirmasi Password harus diisi';
        }

        if (value != _passwordTextboxController.text) {
          return 'Konfirmasi Password tidak sama';
        }

        return null;
      },
    );
  }

  // Tombol Registrasi
  Widget _buttonRegistrasi() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _prosesRegistrasi,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Text('Registrasi'),
      ),
    );
  }

  @override
  void dispose() {
    _namaTextboxController.dispose();
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _namaTextField(),
                const SizedBox(height: 12),

                _emailTextField(),
                const SizedBox(height: 12),

                _passwordTextField(),
                const SizedBox(height: 12),

                _passwordKonfirmasiTextField(),
                const SizedBox(height: 24),

                _buttonRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
