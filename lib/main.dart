import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';
import 'entri_kegiatan.dart';
import 'cetak_kegiatan.dart';
import 'detail_kegiatan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initIp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardKegiatan(),
    );
  }
}

class DashboardKegiatan extends StatefulWidget {
  const DashboardKegiatan({super.key});

  @override
  State<DashboardKegiatan> createState() => _DashboardKegiatanState();
}

class _DashboardKegiatanState extends State<DashboardKegiatan> {
  final String url = urlApi;

  List<dynamic> data = [];
  List<dynamic> filtered = [];
  String filterKategori = "Semua";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final res = await http.post(Uri.parse(url), body: {"aksi": "tampil"});
    data = json.decode(res.body);
    applyFilter();
  }

  void applyFilter() {
    if (filterKategori == "Semua") {
      filtered = data;
    } else {
      filtered = data.where((e) => e["kategori"] == filterKategori).toList();
    }
    setState(() {});
  }

  void hapus(String id) async {
    await http.post(Uri.parse(url), body: {"aksi": "hapus", "id_kegiatan": id});
    loadData();
  }

  void konfirmasiHapus(String id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Hapus Kegiatan"),
            content: const Text("Yakin ingin menghapus kegiatan ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  hapus(id);
                },
                child: const Text("Hapus"),
              ),
            ],
          ),
    );
  }

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

  IconData iconKategori(String kategori) {
    switch (kategori) {
      case "Akademik":
        return Icons.school;
      case "Organisasi":
        return Icons.groups;
      case "Pribadi":
        return Icons.person;
      default:
        return Icons.event_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catatan Kegiatan Harian"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: "Cetak Laporan",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CetakKegiatan(dataCetak: filtered),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Tambah Kegiatan",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EntriKegiatan()),
              ).then((_) => loadData());
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField(
              value: filterKategori,
              decoration: const InputDecoration(
                labelText: "Filter Kategori",
                border: OutlineInputBorder(),
              ),
              items:
                  const ["Semua", "Akademik", "Organisasi", "Pribadi"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (v) {
                filterKategori = v!;
                applyFilter();
              },
            ),
          ),

          Expanded(
            child:
                filtered.isEmpty
                    ? const Center(child: Text("Data belum tersedia"))
                    : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (c, i) {
                        final item = filtered[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: warnaKategori(item["kategori"]),
                              child: Icon(
                                iconKategori(item["kategori"]),
                                color: Colors.white,
                              ),
                            ),

                            title: Text(
                              item["judul_kegiatan"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(item["tanggal"]),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.visibility,
                                    color: Colors.blue,
                                  ),
                                  tooltip: "Detail",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => DetailKegiatan(data: item),
                                      ),
                                    ).then((_) => loadData());
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  tooltip: "Hapus",
                                  onPressed:
                                      () =>
                                          konfirmasiHapus(item["id_kegiatan"]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
