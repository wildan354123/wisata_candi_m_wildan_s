import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wisata_candi/models/candi.dart';

class DetailScreen extends StatelessWidget {
  final Candi candi;

  // Konstruktor yang menerima objek Candi sebagai parameter.
  const DetailScreen({
    super.key,
    required this.candi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Header Detail (gambar utama dan tombol kembali)
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      candi.imageAsset, // Gambar utama candi
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Tombol kembali di atas gambar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100]?.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Aksi untuk kembali ke layar sebelumnya
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ],
            ),

            // Informasi detail Candi (Nama dan ikon favorit)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16), // Spasi
                  Row(
                    children: [],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Nama candi
                            Text(
                              candi.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Ikon favorit (tindakan yang bisa ditambahkan nanti)
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.favorite_border),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Informasi Lokasi, Tahun Dibangun, dan Tipe Candi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 16), // Spasi
                        Row(),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.place, color: Colors.red), // Ikon lokasi
                            SizedBox(width: 8),
                            SizedBox(
                              width: 70,
                              child: Text(
                                'Lokasi', // Label lokasi
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(': ${candi.location}'), // Data lokasi candi
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_month, color: Colors.blue),
                            // Ikon tahun dibangun
                            SizedBox(width: 8),
                            SizedBox(
                              width: 70,
                              child: Text(
                                'Dibangun', // Label tahun dibangun
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(': ${candi.built}'),
                            // Data tahun dibangun
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.house, color: Colors.green),
                            // Ikon tipe candi
                            SizedBox(width: 8),
                            SizedBox(
                              width: 70,
                              child: Text(
                                'Tipe', // Label tipe candi
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(': ${candi.type}'),
                            // Data tipe candi
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bagian Deskripsi Candi
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.deepPurple.shade100),
                        // Garis pemisah
                        Text(
                          'Deskripsi', // Label deskripsi
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Candi Borobudur, candi Buddha terbesar di dunia, dibangun oleh penganut Buddha Mahayana pada abad ke-9 di Jawa Tengah, Indonesia. '
                          'Dengan enam teras dan tiga pelataran melingkar yang dihiasi relief dan arca Buddha, Borobudur adalah tempat suci untuk memuliakan Buddha dan panduan ziarah menuju pencerahan. '
                          'Meskipun ditinggalkan pada abad ke-10, candi ini ditemukan kembali pada tahun 1814 dan setelah pemugaran besar-besaran, diakui sebagai Situs Warisan Dunia oleh UNESCO.',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87), // Konten deskripsi candi
                        ),
                      ],
                    ),
                  ),

                  // Bagian Galeri Candi (gambar-gambar lain)
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.deepPurple.shade100),
                        // Garis pemisah
                        Text(
                          'Galeri', // Label galeri
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Spasi
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // List gambar secara horizontal
                            itemCount: candi.imageUrls.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    // Aksi ketika gambar di-tap
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.deepPurple.shade100,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: candi.imageUrls[index],
                                        // URL gambar
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          width: 120,
                                          height: 120,
                                          color: Colors.deepPurple[50],
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tap Untuk Memperbesar',
                          // Informasi tambahan di bawah galeri
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
