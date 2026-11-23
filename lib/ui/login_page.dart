
import 'package:flutter/material.dart';

import '../bloc/login_bloc.dart';
import '../helpers/user_info.dart';
import '../widget/warning_dialog.dart';

import 'registrasi_page.dart';
import 'produk_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  // ==========================================
  // PROSES LOGIN MENGGUNAKAN BLOC
  // ==========================================

  Future<void> _prosesLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isLoading) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      // Mengirim email dan password ke REST API
      final hasil = await LoginBloc.login(
        email: _emailTextboxController.text.trim(),
        password: _passwordTextboxController.text,
      );

      if (!mounted) return;

      // Memeriksa hasil login dari API CodeIgniter
      if (hasil.status == true &&
          hasil.code == 200 &&
          hasil.token != null &&
          hasil.token.toString().isNotEmpty) {

        // Menyimpan token login
        await UserInfo().setToken(
          hasil.token.toString(),
        );

        // Menyimpan user ID jika tersedia
        final userId = int.tryParse(
          hasil.userID?.toString() ?? '',
        );

        if (userId != null) {
          await UserInfo().setUserID(userId);
        }

        if (!mounted) return;

        // Menampilkan notifikasi login berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login berhasil!'),
            backgroundColor: Colors.green,
          ),
        );

        // Berpindah ke halaman daftar produk
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ProdukPage(),
          ),
          (route) => false,
        );
      } else {
        // Jika email atau password salah
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const WarningDialog(
            description:
                'Login gagal, email atau password salah',
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      // Jika terjadi error koneksi atau server
      debugPrint('Login error: $error');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WarningDialog(
          description:
              'Login gagal, silahkan coba lagi.\n$error',
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
        if (value == null || value.isEmpty) {
          return 'Password harus diisi';
        }

        return null;
      },
    );
  }

  // ==========================================
  // TOMBOL LOGIN
  // ==========================================

  Widget _buttonLogin() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _prosesLogin,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Text('Login'),
      ),
    );
  }

  // ==========================================
  // MENU REGISTRASI
  // ==========================================

  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          'Registrasi',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const RegistrasiPage(),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // DISPOSE CONTROLLER
  // ==========================================

  @override
  void dispose() {
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    super.dispose();
  }

  // ==========================================
  // TAMPILAN HALAMAN LOGIN
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _emailTextField(),
                const SizedBox(height: 12),

                _passwordTextField(),
                const SizedBox(height: 24),

                _buttonLogin(),
                const SizedBox(height: 30),

                _menuRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
