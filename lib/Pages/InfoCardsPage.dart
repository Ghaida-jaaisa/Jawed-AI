import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flip_card/flip_card.dart';

class QuranInfoCardsPage extends StatefulWidget {
  const QuranInfoCardsPage({super.key});

  static final String routeName = '/quranInfoCard';

  @override
  State<QuranInfoCardsPage> createState() => _QuranInfoCardsPageState();
}

class _QuranInfoCardsPageState extends State<QuranInfoCardsPage> {
  List<Map<String, dynamic>> _cards = [];
  final TextStyle _titleStyle = TextStyle(
    // color: Colors.white,
    color: Color(0xFF2FBAC4),
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String jsonString = await rootBundle.loadString(
      'assets/quran_facts.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _cards = List<Map<String, dynamic>>.from(jsonData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('بطاقات معلومات قرآنية', style: _titleStyle),
      ),
      body:
          _cards.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: _cards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    return FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: Card(
                        color: Color(0xFF2FBAC4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              card['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      back: Card(
                        elevation: 10,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              card['content'],
                              style: const TextStyle(
                                color: Color(0xFF2FBAC4),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
