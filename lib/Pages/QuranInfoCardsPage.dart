import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:http/http.dart' as http;

class QuranInfoCardsPage extends StatefulWidget {
  const QuranInfoCardsPage({super.key});

  static final String routeName = '/quranInfoCard';

  @override
  State<QuranInfoCardsPage> createState() => _QuranInfoCardsPageState();
}

class _QuranInfoCardsPageState extends State<QuranInfoCardsPage> {
  List<Map<String, dynamic>> _cards = [];

  @override
  void initState() {
    super.initState();
    fetchFactsFromApi();
  }

  Future<void> fetchFactsFromApi() async {
    final Uri url = Uri.parse('http://jawedai.runasp.net/Home/GetFacts');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        // print(jsonData);
        setState(() {
          _cards = List<Map<String, dynamic>>.from(jsonData);
        });
      } else {
        // Error from server
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      // Network error or invalid JSON
      print('Fetch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'معلومات قرآنية',
          style: TextStyle(
            color: Color(0xFF2FBAC4),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:
          _cards.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: _cards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    return FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: Card(
                        color: const Color(0xFF2FBAC4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              card['title'] ?? '',
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
                              card['content'] ?? '',
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
