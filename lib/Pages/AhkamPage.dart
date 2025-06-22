import 'package:flutter/material.dart';
import 'package:mobileapp/Pages/HukmPage.dart';
// import 'idgham_page.dart';
// import 'ikhfa_page.dart';
// import 'idhhar_page.dart';
// import 'iqlab_page.dart';

class Ahkampage extends StatelessWidget {
  Ahkampage({super.key});
  static const String routeName = '/Ahkampage';

  final List<Map<String, dynamic>> ahkam = [
    {'title': 'الإظهار', 'image': 'assets/images/idhar.png', 'hukmId': 0},
    {'title': 'الإدغام', 'image': 'assets/images/idgham.png', 'hukmId': 1},
    {'title': 'الإخفاء', 'image': 'assets/images/ikhfa.png', 'hukmId': 2},
    {'title': 'الإقلاب', 'image': 'assets/images/iqlab.png', 'hukmId': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'أحكام النون الساكنة والتنوين',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2FBAC4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: GridView.builder(
          itemCount: ahkam.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final item = ahkam[index];
            return GestureDetector(
              onTap:
                  () => Navigator.pushNamed(
                    context,
                    HukmPage.routeName,
                    arguments: item['hukmId'],
                  ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(item['image']),
                    fit: BoxFit.cover,
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