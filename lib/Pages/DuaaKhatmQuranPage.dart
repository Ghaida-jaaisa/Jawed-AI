import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DuaaKhatmQuranPage extends StatelessWidget {
  const DuaaKhatmQuranPage({super.key});

  static final String routeName = '/DuaaKhatmQuranPage';

  Future<String> loadDuaaText() async {
    final response = await http.get(Uri.parse('http://jawedai.runasp.net/Home/GetDuaas'));

    if (response.statusCode == 200) {
      final List<dynamic> duaaList = json.decode(response.body);
      return duaaList.join('\n\n');
    } else {
      throw Exception('فشل تحميل الدعاء من الخادم');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2FBAC4),
        title: const Text(
          'دعاء ختم القرآن',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: loadDuaaText(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ أثناء تحميل الدعاء'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  snapshot.data ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    height: 2,
                    fontFamily: 'Amiri',
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
