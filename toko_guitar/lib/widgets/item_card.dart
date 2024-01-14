import 'package:flutter/material.dart';
import 'package:wisata_candi/model/candi.dart';
import 'package:wisata_candi/screens/detail_screen.dart';
import 'package:wisata_candi/screens/profile_screen.dart';

class ItemCard extends StatelessWidget {
  // TODO: 1. Deklarasi variabel yang dibutuhkan dan dipasang pada konstruktor
  final Candi candi;

  const ItemCard({super.key, required this.candi});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailScreen(candi: candi)));
      },
      child: Card(
        // TODO: 2. Tetapkan parameter shape, margin, dan elevation
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(4),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: 3. Buat Images sebagai anak dari Column
            Expanded(
              child: Hero(
                tag: candi.imageAsset,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    candi.imageAsset,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            //TODO: 4. Buat Text sebagai anak dari column
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                candi.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            //TODO: 5. Buat Text sebagai anak dari column
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                candi.type,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
