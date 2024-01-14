import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_candi/widgets/profil_info_item.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO: 1 Deklarasikan variabel yang dibutuhkan
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  int favoriteCandiCount = 0;

  // TODO: 5 Implementasi fungsi signIn
  void signIn() {
    // setState(() {
    //   isSignedIn = !isSignedIn;
    // });
    Navigator.pushNamed(context, "/signin");
  }

  // TODO: 6 Implementasi fungsi signOut
  void signOut() async {
    // setState(() {
    //   isSignedIn = !isSignedIn;
    // });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', '');
    prefs.setString('username', '');
    prefs.setString('password', '');
    prefs.setBool('isSignedIn', false);
    prefs.remove('key');
    prefs.remove('iv');
    setState(() {
      fullName = '';
      userName = '';
      isSignedIn = false;
    });
  }

  void editFullName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';
    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    dynamic encryptedUsername = prefs.getString('username') ?? '';
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
    encryptedUsername = encrypter.encrypt(decryptedUsername, iv: iv);

    prefs.setString('name', encryptedUsername.base64);
    initState();
  }

  @override
  void initState() {
    super.initState();
    setNameAndUsername();
  }

  void setNameAndUsername() async {
    try {
      final Future<SharedPreferences> prefsFuture =
          SharedPreferences.getInstance();
      final SharedPreferences prefs = await prefsFuture;
      final data = _retrieveAndDecryptDataFromPrefs(prefs);
      if (data.isNotEmpty) {
        final decryptedUsername = data['username'];
        final decryptedName = data['name'];
        setState(() {
          fullName = decryptedName;
          userName = decryptedUsername;
          isSignedIn = true;
        });
      }
    } catch (e) {
      print("Print error $e");
    }
  }

  _retrieveAndDecryptDataFromPrefs(
    SharedPreferences prefs,
  ) {
    final sharedPreferences = prefs;
    final encryptedUsername = sharedPreferences.getString('username') ?? '';
    final encryptedName = sharedPreferences.getString('name') ?? '';
    final keyString = sharedPreferences.getString('key') ?? '';
    final ivString = sharedPreferences.getString('iv') ?? '';

    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
    final decryptedName = encrypter.decrypt64(encryptedName, iv: iv);

    return {'username': decryptedUsername, 'name': decryptedName};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.deepPurple,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // TODO: 2 Buat bagian ProfileHeader yang berisi gambar profil
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 200 - 50),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('images/placeholder_image.png'),
                        ),
                      ),
                      if (isSignedIn)
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.camera_alt,
                                color: Colors.deepPurple[50]))
                    ],
                  ),
                ),
              ),
              // TODO: 3 Buat bagian ProfileInfo yang berisi info profil

              // Pengguna
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.deepPurple[100],
              ),
              SizedBox(
                height: 4,
              ),
              ProfilInfoItem(
                icon: Icons.lock,
                label: "Pengguna",
                value: userName,
                iconColor: Colors.amber,
              ),

              // Nama
              SizedBox(
                height: 4,
              ),
              Divider(
                color: Colors.deepPurple[100],
              ),
              SizedBox(
                height: 4,
              ),
              ProfilInfoItem(
                icon: Icons.person,
                label: "Nama",
                value: fullName,
                iconColor: Colors.blue,
                showEdition: isSignedIn,
                onEditPressed: editFullName,
              ),

              //Favorit
              SizedBox(
                height: 4,
              ),
              Divider(
                color: Colors.deepPurple[100],
              ),
              SizedBox(
                height: 4,
              ),
              ProfilInfoItem(
                icon: Icons.favorite,
                label: "Favorit",
                value: "$favoriteCandiCount",
                iconColor: Colors.red,
              ),

              //Penutup
              SizedBox(
                height: 4,
              ),
              Divider(
                color: Colors.deepPurple[100],
              ),
              SizedBox(
                height: 4,
              ),

              // TODO: 4 Buat ProfileAction yang berisi TextButton sign in/sign out
              isSignedIn
                  ? TextButton(onPressed: signOut, child: Text("Sign Out"))
                  : TextButton(onPressed: signIn, child: Text("Sign In"))
            ],
          ),
        ),
      ],
    ));
  }
}
