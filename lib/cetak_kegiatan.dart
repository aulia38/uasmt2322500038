import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';

class CetakKegiatan extends StatelessWidget {
  final List<dynamic> dataCetak;

  const CetakKegiatan({super.key, required this.dataCetak});

  Future<void> cetakPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build:
            (context) => [
              pw.Text(
                "LAPORAN KEGIATAN HARIAN",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text("Total Kegiatan: ${dataCetak.length}"),
              pw.SizedBox(height: 16),

              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: const pw.TextStyle(fontSize: 10),
                border: pw.TableBorder.all(),
                headers: const [
                  "No",
                  "Tanggal",
                  "Judul",
                  "Kategori",
                  "Deskripsi",
                ],
                data: List.generate(
                  dataCetak.length,
                  (i) => [
                    "${i + 1}",
                    dataCetak[i]["tanggal"] ?? "-",
                    dataCetak[i]["judul_kegiatan"] ?? "-",
                    dataCetak[i]["kategori"] ?? "-",
                    dataCetak[i]["deskripsi"] ?? "-",
                  ],
                ),
              ),
            ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> exportCsv() async {
  final buffer = StringBuffer();
  buffer.writeln("No,Tanggal,Judul,Kategori,Deskripsi");

  for (int i = 0; i < dataCetak.length; i++) {
    buffer.writeln(
      "${i + 1},"
      "${dataCetak[i]["tanggal"] ?? "-"},"
      "\"${dataCetak[i]["judul_kegiatan"] ?? "-"}\","
      "${dataCetak[i]["kategori"] ?? "-"},"
      "\"${dataCetak[i]["deskripsi"] ?? "-"}\"",
    );
  }

  // PILIH FOLDER
  final String? directoryPath = await FilePicker.getDirectoryPath();
  if (directoryPath == null) return;

  // SIMPAN FILE
  final file = File("$directoryPath/laporan_kegiatan.csv");
  await file.writeAsString(buffer.toString());
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Kegiatan"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Kegiatan: ${dataCetak.length}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: cetakPdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("PDF"),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: exportCsv,
                      icon: const Icon(Icons.table_chart),
                      label: const Text("CSV"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child:
                  dataCetak.isEmpty
                      ? const Center(
                        child: Text(
                          "Tidak ada data untuk dicetak",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.all(
                                  Colors.grey.shade200,
                                ),
                                columnSpacing: 32,
                                columns: const [
                                  DataColumn(label: Text("No")),
                                  DataColumn(label: Text("Tanggal")),
                                  DataColumn(label: Text("Judul")),
                                  DataColumn(label: Text("Kategori")),
                                  DataColumn(label: Text("Deskripsi")),
                                ],
                                rows: List.generate(
                                  dataCetak.length,
                                  (i) => DataRow(
                                    cells: [
                                      DataCell(Text("${i + 1}")),
                                      DataCell(
                                        Text(dataCetak[i]["tanggal"] ?? "-"),
                                      ),
                                      DataCell(
                                        Text(
                                          dataCetak[i]["judul_kegiatan"] ?? "-",
                                        ),
                                      ),
                                      DataCell(
                                        Text(dataCetak[i]["kategori"] ?? "-"),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 300,
                                          child: Text(
                                            dataCetak[i]["deskripsi"] ?? "-",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
