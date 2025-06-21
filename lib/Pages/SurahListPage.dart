import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/Pages/DuaaKhatmQuranPage.dart';
import 'package:mobileapp/Pages/HomePage.dart';
import 'package:mobileapp/Pages/QuranInfoCardsPage.dart';
import 'package:mobileapp/Pages/SajdaAyahsPage.dart';
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

class _SurahListPageState extends State<SurahListPage> {
  int _selectedBottomIndex = 0;
  List<Surah> _allSurahs = [];

  @override
  void initState() {
    super.initState();
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

  List<Widget> get _bottomScreens => [
    _buildSurahList(_allSurahs),
    _buildSurahList(
      _allSurahs.where((s) => s.revelationType == "Meccan").toList(),
    ),
    _buildSurahList(
      _allSurahs.where((s) => s.revelationType == "Medinan").toList(),
    ),
  ];

  Widget _buildSurahList(List<Surah> surahs) {
    return ListView.builder(
      itemCount: surahs.length,
      itemBuilder: (ctx, i) {
        final s = surahs[i];
        return ListTile(
          title: Text(
            '${s.number}. ${s.name}',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 18),
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

  Widget _topNavButton({
    required String label,
    required IconData icon,
    required String routeName,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(label, style: TextStyle(fontSize: 14)),
        onPressed: () => Navigator.pushNamed(context, routeName),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2FBAC4),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'أهلاً بك في تطبيق جوّد',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF2FBAC4),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, HomePage.routeName),
            icon: Icon(color: Colors.white, Icons.logout, size: 30),
          ),
        ],
      ),
      body:
          _allSurahs.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _topNavButton(
                          label: 'قراءة القرآن',
                          icon: Icons.menu_book,
                          routeName: AllQuranSurahsPage.routeName,
                        ),
                        _topNavButton(
                          label: 'أدعية قرآنية',
                          icon: Icons.favorite,
                          routeName: QuranicDuaPage.routeName,
                        ),
                        _topNavButton(
                          label: 'أحكام التجويد',
                          icon: Icons.record_voice_over,
                          routeName: Ahkampage.routeName,
                        ),
                        _topNavButton(
                          label: 'معلومات قرآنية',
                          icon: FontAwesomeIcons.lightbulb,
                          routeName: QuranInfoCardsPage.routeName,
                        ),
                        _topNavButton(
                          label: 'ادعية ختم القران',
                          icon: FontAwesomeIcons.lightbulb,
                          routeName: DuaaKhatmQuranPage.routeName,
                        ),
                        _topNavButton(
                          label: 'ايات السجدة',
                          icon: FontAwesomeIcons.lightbulb,
                          routeName: SajdaAyahsPage.routeName,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: _bottomScreens[_selectedBottomIndex]),
                ],
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: (index) => setState(() => _selectedBottomIndex = index),
        items: [
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
}

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