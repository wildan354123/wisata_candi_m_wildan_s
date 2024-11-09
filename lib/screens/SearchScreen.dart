import 'package:flutter/material.dart';
import 'package:wisata_candi/models/candi.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  // todo 1. Deklarasikan variabel yang dibutuhkan
  List<Candi> _filteredCandis = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // todo: 2. Buat aoobar dengan judul pencarian candi
        appBar: AppBar(
          title: Text('Pencarian Candi'),
        ),
        // todo: 3. Buat body berupa column
        body: Column(
          children: [
            // todo: 4. Buat TextField pencarian
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.deepPurple[50],
                ),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Cari Candi ...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple)),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      )),
                ),
              ),
            ),
            // todo: 5. Buat ListView hasil pencarian sebagai anak dari column
            ListView.builder(
              itemCount: _filteredCandis.length,
              itemBuilder: (context, index) {
                final candi = _filteredCandis[index];
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRect(
                          child: Image.asset(candi.imageAsset, fit: BoxFit.cover))
                      
                    ],
                  ),
                );
              },
            )
          ],
        ));
  }
}
