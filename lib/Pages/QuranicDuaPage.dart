import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

class Dua {
  final String verse;
  final String surah;
  final String ayahNumber;

  Dua({required this.verse, required this.surah, required this.ayahNumber});
}

class QuranicDuaPage extends StatefulWidget {
  static const String routeName = '/quranicDua';

  @override
  State<QuranicDuaPage> createState() => _QuranicDuaPageState();
}

class _QuranicDuaPageState extends State<QuranicDuaPage> {
  late Future<List<Dua>> _future;

  Future<List<Dua>> fetchQuranicDuas() async {
    final response = await http.get(Uri.parse('http://jawedai.runasp.net/Home/GetQuranVerses'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((item) {
        return Dua(
          verse: item['verse'] ?? '',
          surah: item['surah'] ?? '',
          ayahNumber: item['ayah']?.toString() ?? '',
        );
      }).toList();
    } else {
      throw Exception('فشل في جلب البيانات من الخادم');
    }
  }

  @override
  void initState() {
    super.initState();
    _future = fetchQuranicDuas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'أدعية من القرآن',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF2FBAC4),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Dua>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد أدعية متاحة'));
          }

          final duas = snapshot.data!;
          return ListView.builder(
            itemCount: duas.length,
            itemBuilder: (context, i) {
              final d = duas[i];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    d.verse,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    '${d.surah} - آية ${d.ayahNumber}',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.copy, color: Color(0xFF2FBAC4)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: d.verse));
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('تم نسخ الدعاء')));
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
