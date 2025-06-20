import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Dua {
  final String verse, surah, ayahNumber;
  Dua({required this.verse, required this.surah, required this.ayahNumber});
}

Future<List<Dua>> fetchQuranicDuas(String keyword) async {
  final url = 'https://api.alquran.cloud/v1/search/$keyword/all/quran-uthmani';
  final resp = await http.get(Uri.parse(url));

  if (resp.statusCode == 200) {
    final data = jsonDecode(resp.body)['data']['matches'] as List;
    return data.map((m) => Dua(
      verse: m['text'],
      surah: m['surah']['name'],
      ayahNumber: m['numberInSurah'].toString(),
    )).toList();
  } else {
    throw Exception('فشل بجلب الأدعية');
  }
}

class QuranicDuaPage extends StatefulWidget {
  @override
  _QuranicDuaPageState createState() => _QuranicDuaPageState();
  static const String routeName = '/quranicDua';

}

class _QuranicDuaPageState extends State<QuranicDuaPage> {
  late Future<List<Dua>> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchQuranicDuas('ربنا');
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أدعية من القرآن' ,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: Color(0xFF2FBAC4),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Dua>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          final duas = snapshot.data!;
          return ListView.builder(
            itemCount: duas.length,
            itemBuilder: (context, i) {
              final d = duas[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    d.verse,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    '${d.surah} - آية ${d.ayahNumber}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, color: Color(0xFF2FBAC4)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: d.verse));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم نسخ الدعاء')),
                      );
                    },
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
