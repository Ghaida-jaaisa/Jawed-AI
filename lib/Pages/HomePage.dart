import 'package:flutter/material.dart';
import 'package:mobileapp/Pages/LoginPage.dart';
import 'package:mobileapp/Pages/RegisterPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // If we decide to change icon using FontAwesomeIcons

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/HomePage';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Logo
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),

              //  Quran facts
              Column(
                children: const [
                  QuranFactCard(text: '📖 عدد سور القرآن الكريم: 114 سورة'),
                  QuranFactCard(text: '🧩 عدد الأجزاء: 30 جزءاً'),
                  QuranFactCard(text: '📜 عدد الآيات: 6236 آية'),
                ],
              ),
              //  Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginPage.routeName);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2FBAC4),
                        ),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.routeName);
                        },
                        child: const Text(
                          'إنشاء حساب',
                          style: TextStyle(color: Color(0xFF2FBAC4)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuranFactCard extends StatelessWidget {
  final String text;
  const QuranFactCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 30.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: horizontalPadding),
      child: SizedBox(
        width: screenWidth - 2 * horizontalPadding,
        child: Card(
          color: const Color(0xFFAEDDE5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
          child: Opacity(
            opacity: 0.9,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
