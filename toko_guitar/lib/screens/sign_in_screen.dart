import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_candi/screens/sign_up_screen.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';
  bool _isSignedIn = false;
  bool _obscurePassword = true;

  void _signIn() async {
    try {
      final Future<SharedPreferences> prefsFuture =
          SharedPreferences.getInstance();
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      print("Sign in attempt");

      if (username.isNotEmpty && password.isNotEmpty) {
        final SharedPreferences prefs = await prefsFuture;
        final data = _retrieveAndDecryptDataFromPrefs(prefs);
        if (data.isNotEmpty) {
          final decryptedUsername = data['username'];
          final decryptedPassword = data['password'];

          if (username == decryptedUsername && password == decryptedPassword) {
            _errorText = '';
            _isSignedIn = true;
            prefs.setBool('isSignedIn', true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, "/");
            });
            print("Sign in berhasil");
          } else {
            print('Username atau password salah');
          }
        } else {
          print('Anda belum terdaftar di aplikasi ini');
        }
      } else {
        print('Username atau password belum terisi');
      }
    } catch (e) {
      print('An error occured: $e');
    }
  }

  _retrieveAndDecryptDataFromPrefs(
    SharedPreferences prefs,
  ) {
    final sharedPreferences = prefs;
    final encryptedUsername = sharedPreferences.getString('username') ?? '';
    final encryptedPassword = sharedPreferences.getString('password') ?? '';
    final keyString = sharedPreferences.getString('key') ?? '';
    final ivString = sharedPreferences.getString('iv') ?? '';

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
    final decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);

    return {'username': decryptedUsername, 'password': decryptedPassword};
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
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
                ElevatedButton(onPressed: _signIn, child: Text("Sign In")),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text('Belum punya akun? Daftar di sini.'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
