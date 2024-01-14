import 'package:flutter/material.dart';
import 'package:wisata_candi/data/candi_data.dart';
import 'package:wisata_candi/model/candi.dart';
import 'package:wisata_candi/widgets/item_card.dart';

class HomeSceeen extends StatefulWidget {
  const HomeSceeen({super.key});

  @override
  State<HomeSceeen> createState() => _HomeSceeenState();
}

class _HomeSceeenState extends State<HomeSceeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: 1. Buat appbar dengan judul Wisata Candi
      appBar: AppBar(title: const Text('Wisata Candi')),

      // TODO: 2. Buat Body dengan GridView.builder
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: const EdgeInsets.all(8),
        itemCount: candiList.length,
        itemBuilder: (context, index) {
          // TODO: 3. Buat ItemCard sebagai return value dari GridView.builder
          Candi candi = candiList[index];
          return ItemCard(candi: candi);
        },
      ),
    );
  }
}
