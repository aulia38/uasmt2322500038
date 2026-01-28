import 'package:flutter/services.dart';

late String ip;

Future<void> initIp() async {
  ip = (await rootBundle.loadString("assets/ip.txt")).trim();
}

String get urlApi => "http://$ip/kegiatan_harian/kegiatan.php";
String get urlFoto => "http://$ip/kegiatan_harian/foto.php?f=";
