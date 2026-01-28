import 'package:flutter/material.dart';
import 'globals.dart';
import 'entri_kegiatan.dart';

class DetailKegiatan extends StatelessWidget {
  final Map data;
  const DetailKegiatan({super.key, required this.data});

  Color warnaKategori(String kategori) {
    switch (kategori) {
      case "Akademik":
        return Colors.blue;
      case "Organisasi":
        return Colors.green;
      case "Pribadi":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Detail Kegiatan"),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.edit),
        label: const Text("Edit Kegiatan"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EntriKegiatan(data: data)),
          ).then((_) => Navigator.pop(context));
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["judul_kegiatan"] ?? "-",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Chip(
                  label: Text(data["kategori"]),
                  backgroundColor: warnaKategori(data["kategori"]),
                  labelStyle: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 20),
                const Divider(),

                _infoRow(
                  icon: Icons.calendar_today,
                  label: "Tanggal",
                  value: data["tanggal"],
                ),

                const SizedBox(height: 16),

                _infoRow(
                  icon: Icons.description,
                  label: "Deskripsi",
                  value: data["deskripsi"],
                  multiline: true,
                ),

                if (data["foto"] != null &&
                    data["foto"].toString().isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    "Dokumentasi Kegiatan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "$urlFoto${data["foto"]}",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            height: 180,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 48),
                            ),
                          ),
                    ),
                  ),
                ],

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    bool multiline = false,
  }) {
    return Row(
      crossAxisAlignment:
          multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
