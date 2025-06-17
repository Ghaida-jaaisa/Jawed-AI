import 'package:flutter/material.dart';
import 'idgham_page.dart';
import 'ikhfa_page.dart';
import 'idhhar_page.dart';
import 'iqlab_page.dart';

class Ahkampage extends StatelessWidget {
  final List<Map<String, dynamic>> ahkam = [
    {
      'title': 'الإدغام',
      'image': 'assets/images/idgham.png',
      'page': IdghamPage(),
    },
    {
      'title': 'الإخفاء',
      'image': 'assets/images/ikhfa.png',
      'page': IkhfaPage(),
    },
    {
      'title': 'الإظهار',
      'image': 'assets/images/idhar.png',
      'page': IdhharPage(),
    },
    {
      'title': 'الإقلاب',
      'image': 'assets/images/iqlab.png',
      'page': IqlabPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أحكام النون الساكنة والتنوين'),
        backgroundColor: Colors.teal,
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
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item['page']),
                  );
                },
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
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.asset(
                          item['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   left: 0,
                        //   right: 0,
                        //   child: Container(
                        //     color: Colors.black.withOpacity(0.6),
                        //     padding: EdgeInsets.symmetric(vertical: 6),
                        //     child: Center(
                        //       child: Text(
                        //         item['title'],
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
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