import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

class Dua {
  final String verse;
  final String surah;
  final String ayahNumber;

  Dua({
    required this.verse,
    required this.surah,
    required this.ayahNumber,
  });
}

class QuranicDuaPage extends StatefulWidget {
  static const String routeName = '/quranicDua';

  @override
  State<QuranicDuaPage> createState() => _QuranicDuaPageState();
}

class _QuranicDuaPageState extends State<QuranicDuaPage> {
  late Future<List<Dua>> _future;

  Future<List<Dua>> fetchQuranicDuas() async {
    final String jsonString = await rootBundle.loadString('assets/duas.json');
    // print(jsonString);
    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((item) {
      return Dua(
        verse: item['verse'],
        surah: item['surah'],
        ayahNumber: item['ayah'],
      );
    }).toList();
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
        title: const Text(
          'أدعية من القرآن',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2FBAC4),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Dua>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد أدعية متاحة'));
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
