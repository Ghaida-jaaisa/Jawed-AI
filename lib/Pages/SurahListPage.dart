// lib/Pages/SurahListPage.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'SurahDetailPage.dart';
import 'AllQuranSurahsPage.dart';
import 'QuranicDuaPage.dart';
import 'AhkamPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SurahListPage extends StatefulWidget {
  const SurahListPage({super.key});

  static const String routeName = '/surah-list';

  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedBottomIndex = 0;
  List<Surah> _allSurahs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    ); // بدون "قائمة السور"

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      switch (_tabController.index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AllQuranSurahsPage()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => QuranicDuaPage()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Ahkampage()),
          );
          break;
      }

      // _tabController.animateTo(0); // الرجوع لأول تبويب بعد التنقل
    });

    _fetchSurahs();
  }

  Future<void> _fetchSurahs() async {
    final uri = Uri.parse('https://api.alquran.cloud/v1/surah');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body)['data'] as List;
      setState(() {
        _allSurahs = data.map((j) => Surah.fromJson(j)).toList();
      });
    } else {
      throw Exception('فشل في تحميل السور');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> get _bottomScreens => [
    _buildSurahList(_allSurahs),
    // قائمة السور
    _buildSurahList(
      _allSurahs.where((s) => s.revelationType == "Meccan").toList(),
    ),
    // مكية
    _buildSurahList(
      _allSurahs.where((s) => s.revelationType == "Medinan").toList(),
    ),
    // مدنية
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أهلاً بك في تطبيق جوّد ...',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF2FBAC4),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            // Tab(icon: SizedBox.shrink()),
            Tab(text: 'قراءة القرآن', icon: Icon(Icons.menu_book)),
            Tab(text: 'أدعية قرآنية', icon: Icon(Icons.favorite)),
            Tab(text: 'أحكام التجويد', icon: Icon(Icons.record_voice_over)),
          ],
          labelStyle: const TextStyle(fontSize: 14),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      body:
          _allSurahs.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _bottomScreens[_selectedBottomIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: (index) => setState(() => _selectedBottomIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'قائمة السور'),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.kaaba),
            label: 'السور المكية',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.mosque),
            label: 'السور المدنية',
          ),
        ],
        selectedItemColor: Color(0xFF2FBAC4),
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildSurahList(List<Surah> surahs) {
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
  }
}

/// نموذج بيانات السورة
class Surah {
  final int number;
  final String name;
  final String englishName;
  final int numberOfAyahs;
  final String revelationType;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> j) => Surah(
    number: j['number'],
    name: j['name'],
    englishName: j['englishName'],
    numberOfAyahs: j['numberOfAyahs'],
    revelationType: j['revelationType'],
  );
}
