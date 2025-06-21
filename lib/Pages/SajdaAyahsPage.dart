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
  List<dynamic> sajdaAyahs = [];

  @override
  void initState() {
    super.initState();
    fetchSajdaAyahs();
  }

  Future<void> fetchSajdaAyahs() async {
    final res = await http.get(
      Uri.parse('http://api.alquran.cloud/v1/sajda/quran-uthmani'),
    );
    final json = jsonDecode(res.body);
    setState(() {
      sajdaAyahs = json['data']['ayahs'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('آيات السجدة')),
      body:
          sajdaAyahs.isEmpty
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : ListView.builder(
                itemCount: sajdaAyahs.length,
                itemBuilder: (context, index) {
                  final ayah = sajdaAyahs[index];
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          '📖 ${ayah["surah"]["name"]} | الآية ${ayah["numberInSurah"]}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            ayah["text"],
                            textAlign: TextAlign.right,
                            style: TextStyle(
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