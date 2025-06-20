// lib/Pages/SurahListPage.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'SurahDetailPage.dart';
import 'AllQuranSurahsPage.dart'; // صفحة قراءة القرآن
import 'QuranicDuaPage.dart'; // صفحة الأدعية
import 'AhkamPage.dart'; // صفحة الأحكام

class SurahListPage extends StatefulWidget {
  const SurahListPage({super.key});
  static const String routeName = '/surah-list';

  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Future<List<Surah>> _fetchSurahs() async {
    final uri = Uri.parse('https://api.alquran.cloud/v1/surah');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('فشل في تحميل السور');
    final data = json.decode(res.body)['data'] as List;
    return data.map((j) => Surah.fromJson(j)).toList();
  }

  final List<Tab> _tabs = const [
    Tab(text: 'قائمة السور', icon: Icon(Icons.list_alt)),
    Tab(text: 'قراءة القرآن', icon: Icon(Icons.menu_book)),
    Tab(text: 'أدعية قرآنية', icon: Icon(Icons.favorite)),
    Tab(text: 'أحكام التجويد', icon: Icon(Icons.record_voice_over)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      switch (_tabController.index) {
        case 0:
          // No Action - Current Page
          break;
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AllQuranSurahsPage()));
          // Navigator.pushNamed(context, AllQuranSurahsPage.routeName);
          break;
        case 2:
          Navigator.push(context, MaterialPageRoute(builder: (_) => QuranicDuaPage()));
          break;
        case 3:
          Navigator.push(context, MaterialPageRoute(builder: (_) => Ahkampage()));
          break;
      }

      // إعادة المستخدم لتبويب قائمة السور بعد التنقل
      _tabController.animateTo(0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أهلاً بك ... ', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2FBAC4),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelStyle: const TextStyle(fontSize: 14),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelPadding: const EdgeInsets.symmetric(vertical: 8),
          // iconTheme: const IconThemeData(color: Colors.white),
          // unselectedIconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: _buildSurahListTab(),
    );
  }

  Widget _buildSurahListTab() {
    return FutureBuilder<List<Surah>>(
      future: _fetchSurahs(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('خطأ: ${snap.error}'));
        }
        final surahs = snap.data!;
        return ListView.builder(
          itemCount: surahs.length,
          itemBuilder: (ctx, i) {
            final s = surahs[i];
            return ListTile(
              title: Text(
                '${s.number}. ${s.name}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                '${s.englishName} • ${s.numberOfAyahs} آيات',
                textAlign: TextAlign.right,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SurahDetailPage.routeName,
                  arguments: s,
                );
              },
            );
          },
        );
      },
    );
  }
}

/// نموذج بيانات السورة
class Surah {
  final int number;
  final String name;
  final String englishName;
  final int numberOfAyahs;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.numberOfAyahs,
  });

  factory Surah.fromJson(Map<String, dynamic> j) => Surah(
    number: j['number'],
    name: j['name'],
    englishName: j['englishName'],
    numberOfAyahs: j['numberOfAyahs'],
  );
}
