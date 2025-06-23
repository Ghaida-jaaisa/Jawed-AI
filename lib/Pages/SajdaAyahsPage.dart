import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SajdaAyahsPage extends StatefulWidget {
  const SajdaAyahsPage({Key? key}) : super(key: key);
  static final String routeName = '/SajdaAyahsPage';

  @override
  State<SajdaAyahsPage> createState() => _SajdaAyahsPageState();
}

class _SajdaAyahsPageState extends State<SajdaAyahsPage> {
  late Future<List<dynamic>> _futureSajdaAyahs;

  @override
  void initState() {
    super.initState();
    _futureSajdaAyahs = fetchSajdaAyahs();
  }

  Future<List<dynamic>> fetchSajdaAyahs() async {
    final res = await http.get(
      Uri.parse('http://api.alquran.cloud/v1/sajda/quran-uthmani'),
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return json['data']['ayahs'];
    } else {
      throw Exception('فشل في جلب البيانات: ${res.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('آيات السجدة'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureSajdaAyahs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          final sajdaAyahs = snapshot.data!;

          return ListView.builder(
            itemCount: sajdaAyahs.length,
            itemBuilder: (context, index) {
              final ayah = sajdaAyahs[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      '📖 ${ayah["surah"]["name"]} | الآية ${ayah["numberInSurah"]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
          );
        },
      ),
    );
  }
}
