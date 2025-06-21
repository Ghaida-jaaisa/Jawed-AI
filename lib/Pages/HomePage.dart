import 'package:flutter/material.dart';
import 'package:mobileapp/Pages/LoginPage.dart';
import 'package:mobileapp/Pages/RegisterPage.dart';

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Logo
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),

                Column(
                  children: [
                    Container(
                      child: Text('📖 عدد سور القرآن الكريم: 114 سورة'),
                      color: Color(0xFFAEDDE5),
                      width: screenWidth,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: Text('🧩 عدد الأجزاء: 30 جزءاً'),
                      color: Color(0xFFAEDDE5),
                      width: screenWidth,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: Text('📜 عدد الآيات: 6236 آية'),
                      color: Color(0xFFAEDDE5),
                      width: screenWidth,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                    ),
                  ],
                ),
                //  Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginPage.routeName);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2FBAC4),
                        ),
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.routeName);
                        },
                        child: Text(
                          'إنشاء حساب',
                          style: TextStyle(color: Color(0xFF2FBAC4)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}