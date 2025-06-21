import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class SajdaAyahsPage extends StatefulWidget {
  const SajdaAyahsPage({Key? key}) : super(key: key);
  static final String routeName = '/SajdaAyahsPage';

  @override
  State<SajdaAyahsPage> createState() => _SajdaAyahsPageState();
}

class _SajdaAyahsPageState extends State<SajdaAyahsPage> {
  List<dynamic> sajdaAyahs = [];

  @override
  void initState() {
    super.initState();
    fetchSajdaAyahs();
  }

  Future<void> fetchSajdaAyahs() async {
    final res = await http.get(Uri.parse('http://api.alquran.cloud/v1/sajda/quran-uthmani'));
    final json = jsonDecode(res.body);
    setState(() {
      sajdaAyahs = json['data']['ayahs'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(FontAwesomeIcons.mosque),
        title: const Text('آيات السجدة'),
        // backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: sajdaAyahs.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
        itemCount: sajdaAyahs.length,
        itemBuilder: (context, index) {
          final ayah = sajdaAyahs[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500 + index * 100),
              curve: Curves.easeOutExpo,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Color(0xFF1B263B), Color(0xFFAEDDE5)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  '📖 ${ayah["surah"]["name"]} | الآية ${ayah["numberInSurah"]}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    ayah["text"],
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
