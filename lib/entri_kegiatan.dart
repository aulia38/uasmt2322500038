import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'globals.dart';

class EntriKegiatan extends StatefulWidget {
  final Map? data;
  const EntriKegiatan({super.key, this.data});

  @override
  State<EntriKegiatan> createState() => _EntriKegiatanState();
}

class _EntriKegiatanState extends State<EntriKegiatan> {
  final _formKey = GlobalKey<FormState>();

  final tanggalCtrl = TextEditingController();
  final judulCtrl = TextEditingController();
  final deskripsiCtrl = TextEditingController();

  String kategori = "Akademik";

  Uint8List? imageBytes;
  String? imageName;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      edit = true;
      tanggalCtrl.text = widget.data!["tanggal"];
      judulCtrl.text = widget.data!["judul_kegiatan"];
      deskripsiCtrl.text = widget.data!["deskripsi"];
      kategori = widget.data!["kategori"];
      imageName = widget.data!["foto"];
    }
  }

  Future<void> pilihTanggal() async {
    DateTime initialDate = DateTime.now();

    if (tanggalCtrl.text.isNotEmpty) {
      initialDate = DateTime.parse(tanggalCtrl.text);
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      tanggalCtrl.text = picked.toIso8601String().substring(0, 10);
      setState(() {});
    }
  }

  Future<void> pilihGambar() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      imageBytes = await img.readAsBytes();
      imageName = img.name;
      setState(() {});
    }
  }

  Future<void> simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final req = http.MultipartRequest("POST", Uri.parse(urlApi));

    req.fields.addAll({
      "aksi": edit ? "ubah" : "simpan",
      "tanggal": tanggalCtrl.text,
      "judul_kegiatan": judulCtrl.text,
      "deskripsi": deskripsiCtrl.text,
      "kategori": kategori,
      "tanggal_input": DateTime.now().toIso8601String().substring(0, 10),
    });

    if (edit) {
      req.fields["id_kegiatan"] = widget.data!["id_kegiatan"];
    }

    if (imageBytes != null) {
      req.files.add(
        http.MultipartFile.fromBytes("foto", imageBytes!, filename: imageName),
      );
    }

    await req.send();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(edit ? "Edit Kegiatan" : "Tambah Kegiatan"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: tanggalCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Tanggal Kegiatan",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: pilihTanggal,
                validator: (v) => v!.isEmpty ? "Tanggal wajib dipilih" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: judulCtrl,
                decoration: const InputDecoration(labelText: "Judul Kegiatan"),
                validator: (v) => v!.isEmpty ? "Judul wajib diisi" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: deskripsiCtrl,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                maxLines: 3,
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField(
                value: kategori,
                decoration: const InputDecoration(labelText: "Kategori"),
                items:
                    const ["Akademik", "Organisasi", "Pribadi"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (v) => setState(() => kategori = v!),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: pilihGambar,
                icon: const Icon(Icons.image),
                label: const Text("Pilih Foto Dokumentasi"),
              ),

              const SizedBox(height: 8),

              Container(
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    imageBytes != null
                        ? Image.memory(imageBytes!, fit: BoxFit.cover)
                        : (imageName != null
                            ? Image.network(
                              "$urlFoto$imageName",
                              fit: BoxFit.cover,
                            )
                            : const Center(child: Text("Belum ada foto"))),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: simpan,
                child: const Text("Simpan", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
