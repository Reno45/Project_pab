import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_candi/model/candi.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.candi});
  final Candi candi;

  @override
  State<DetailScreen> createState() => _DetailScreenState(candi: candi);
}

//TODO: 1 Implementasi sisa dari DetailScreen
class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState({required this.candi});
  final Candi candi;
  bool isFavorite = false;
  bool isSignIn = false; // Menyimpan status sign in

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
    _loadFavoriteStatus();
  }

//Memeriksa status sign in
  void _checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool signedIn = prefs.getBool('isSignedIn') ?? false;
    setState(() {
      isSignIn = signedIn;
    });
  }

  // Memeriksa status favorite
  void _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool favorite = prefs.getBool('favorite_${widget.candi.name}') ?? false;
    setState(() {
      isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!isSignIn) {
      //jika belum sign in, diarahkan ke Sign In Screen
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, '/signin');
      });
      return;
    }

    bool favoriteStatus = !isFavorite;
    prefs.setBool('favorite_${widget.candi.name}', favoriteStatus);

    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              Hero(
                tag: widget.candi.imageAsset,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.candi.imageAsset,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.deepPurple[100]?.withOpacity(0.8),
                      shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                      )),
                ),
              ),
            ],
          ),
          //Detail Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      candi.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          _toggleFavorite();
                        },
                        icon: Icon(
                          isSignIn && isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isSignIn && isFavorite ? Colors.red : null,
                        ))
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 70,
                      child: Text(
                        'Lokasi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      ': ${candi.location}',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 70,
                      child: Text(
                        'Dibangun',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      ': ${candi.built}',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.house,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 70,
                      child: Text(
                        'Tipe',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      ': ${candi.type}',
                    ),
                  ],
                ),
                SizedBox(
                  width: 16,
                ),
                Divider(
                  color: Colors.deepPurple.shade100,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(candi.description)
              ],
            ),
          ),
          //Detail Galery
          Padding(
            padding: const EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(
                color: Colors.deepPurple.shade100,
              ),
              Text(
                'Galery',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: candi.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.deepPurple.shade100,
                                    width: 2)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: candi.imageUrls[index],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 120,
                                  height: 120,
                                  color: Colors.deepPurple[50],
                                ),
                                errorWidget: (context, Url, error) =>
                                    Icon(Icons.error),
                              ),
                            )),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                'Tap Untuk Memperbesar',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
