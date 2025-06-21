import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DuaaKhatmQuranPage extends StatelessWidget {
  const DuaaKhatmQuranPage({super.key});

  static final String routeName = '/DuaaKhatmQuranPage';

  Future<String> loadDuaaText() async {
    final String response = await rootBundle.loadString(
      'assets/duaa_khatm_quran.json',
    );
    final data = json.decode(response);
    final List<dynamic> duaaList = data['duaa'];
    return duaaList.join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2FBAC4),
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
                child: Directionality(
                  textDirection: TextDirection.rtl,
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
              ),
            );
          }
        },
      ),
    );
  }
}
