import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameC = TextEditingController();
  final _addressC = TextEditingController();
  final _phoneC = TextEditingController();
  final _emailC = TextEditingController();
  final _usernameC = TextEditingController();
  final _passwordC = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameC.dispose();
    _addressC.dispose();
    _phoneC.dispose();
    _emailC.dispose();
    _usernameC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Widget _input(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white70,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_emailC.text.isEmpty ||
        _usernameC.text.isEmpty ||
        _passwordC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email, username, password wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.register(
      name: _nameC.text.trim().isEmpty
          ? _usernameC.text.trim()
          : _nameC.text.trim(),
      username: _usernameC.text.trim(),
      email: _emailC.text.trim(),
      password: _passwordC.text.trim(),
      phone: _phoneC.text.trim(),
      address: _addressC.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Register berhasil, silakan login')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Register gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00B4FF),
              Color(0xFF001F3F),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "BUAT AKUN BARU",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [Shadow(blurRadius: 1, offset: Offset(0, 0))],
                  ),
                ),
                const SizedBox(height: 40),
                _input(_nameC, "Nama Lengkap"),
                const SizedBox(height: 12),
                _input(_addressC, "Alamat"),
                const SizedBox(height: 12),
                _input(_phoneC, "Nomor HP"),
                const SizedBox(height: 12),
                _input(_emailC, "Email"),
                const SizedBox(height: 12),
                _input(_usernameC, "Username"),
                const SizedBox(height: 12),
                _input(_passwordC, "Password"),
                const SizedBox(height: 30),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0095FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleRegister,
                    child: Text(
                      _isLoading ? "Loading..." : "Register",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
