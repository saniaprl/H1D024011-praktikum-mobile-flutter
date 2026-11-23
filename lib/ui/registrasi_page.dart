
import 'package:flutter/material.dart';

import '../bloc/registrasi_bloc.dart';
import '../widget/success_dialog.dart';
import '../widget/warning_dialog.dart';
import 'login_page.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() =>
      _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  final _konfirmasiPasswordController =
      TextEditingController();

  // ==========================================
  // PROSES REGISTRASI MENGGUNAKAN BLOC
  // ==========================================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isLoading) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      // Mengirim data registrasi ke REST API
      final hasil = await RegistrasiBloc.registrasi(
        nama: _namaTextboxController.text.trim(),
        email: _emailTextboxController.text.trim(),
        password: _passwordTextboxController.text,
      );

      if (!mounted) return;

      // Memeriksa hasil registrasi dari API
      if (hasil.status == true && hasil.code == 200) {
        // Menampilkan dialog sukses
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SuccessDialog(
              description:
                  "Registrasi berhasil, silahkan login",
              okClick: () {
                // Berpindah ke halaman Login
                Navigator.pushReplacement(
                  this.context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginPage(),
                  ),
                );
              },
            );
          },
        );
      } else {
        // Menampilkan dialog jika registrasi gagal
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WarningDialog(
              description:
                  hasil.data?.toString() ??
                  "Registrasi gagal, silahkan coba lagi",
            );
          },
        );
      }
    } catch (error) {
      if (!mounted) return;

      // Menampilkan dialog ketika terjadi error
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WarningDialog(
            description:
                "Registrasi gagal, silahkan coba lagi.\n$error",
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
  // TEXTBOX NAMA
  // ==========================================

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

  // ==========================================
  // TEXTBOX EMAIL
  // ==========================================

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

  // ==========================================
  // TEXTBOX PASSWORD
  // ==========================================

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

  // ==========================================
  // TEXTBOX KONFIRMASI PASSWORD
  // ==========================================

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

  // ==========================================
  // TOMBOL REGISTRASI
  // ==========================================

  Widget _buttonRegistrasi() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
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

  // ==========================================
  // DISPOSE CONTROLLER
  // ==========================================

  @override
  void dispose() {
    _namaTextboxController.dispose();
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  // ==========================================
  // TAMPILAN HALAMAN REGISTRASI
  // ==========================================

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
