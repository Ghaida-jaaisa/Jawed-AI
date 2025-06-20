import 'package:flutter/material.dart';
import 'package:mobileapp/Pages/LoginPage.dart';
import 'package:mobileapp/Pages/RegisterPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/HomePage';

  @override
  Widget build(BuildContext context) {
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
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              Column(
                children: const [
                  QuranFactCard(text: '📖 عدد سور القرآن: 114 سورة'),
                  QuranFactCard(text: '🕌 أطول سورة: البقرة – 286 آية'),
                  QuranFactCard(text: '🌟 أقصر سورة: الكوثر – 3 آيات'),
                ],
              ),
              // 🔹 Buttons
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
                        child: const Text('تسجيل الدخول' , style: TextStyle(
                          color: Colors.white
                        ),),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.routeName);
                        },
                        child: const Text('إنشاء حساب', style: TextStyle(
                          color: const Color (0xFF2FBAC4)
                        ),),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Card(
        color: const Color(0xFFAEDDE5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        child: Opacity(
          opacity: 0.8,
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
    );

  }
}
//