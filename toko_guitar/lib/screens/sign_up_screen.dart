import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';
  bool _isSignedIn = false;
  bool _obscurePassword = true;

  void _signUp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = _fullnameController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Gagal karena ada yang kosong
    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = "Ada field yang kosong";
      });
      // Gagal karena password tidak sesuai
    } else if (!(password.length > 8) ||
        !(password.contains(RegExp(r'[A-Z]'))) ||
        !(password.contains(RegExp(r'[a-z]'))) ||
        !(password.contains(RegExp(r'[0-9]'))) ||
        !(password.contains(RegExp(r'[!@#\\\$%^&*(),.?":{}|<>]')))) {
      setState(() {
        _errorText = "Password tidak sesuai kriteria";
      });
      // Berhasil
    } else {
      setState(() {
        _errorText = "";
      });
      final encrypt.Key key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encryptedName = encrypter.encrypt(name, iv: iv);
      final encryptedUsername = encrypter.encrypt(username, iv: iv);
      final encryptedPassword = encrypter.encrypt(password, iv: iv);

      prefs.setString('name', encryptedName.base64);
      prefs.setString('username', encryptedUsername.base64);
      prefs.setString('password', encryptedPassword.base64);
      prefs.setString('key', key.base64);
      prefs.setString('iv', iv.base64);

      print("Nama belum terenkripsi : $name");
      print("Nama sudah terenkripsi : " + encryptedName.base64);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fullnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _fullnameController,
                  decoration: InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Nama Pengguna",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: "Kata Sandi",
                      errorText: _errorText.isNotEmpty ? _errorText : null,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )),
                  obscureText: _obscurePassword,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: _signUp, child: Text("Sign Up")),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
