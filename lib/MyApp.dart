import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobileapp/Pages/AhkamPage.dart';
import 'package:mobileapp/Pages/ForgotPasswordPage.dart';
import 'package:mobileapp/Pages/HukmPage.dart';
import 'package:mobileapp/Pages/ResetPasswordPage.dart';
import 'package:mobileapp/Pages/SurahDetailPage.dart';
import 'package:mobileapp/Pages/SurahListPage.dart';
import 'package:mobileapp/generated/l10n.dart';
import 'package:mobileapp/Pages/HomePage.dart';
import 'package:mobileapp/Pages/LoginPage.dart';
import 'package:mobileapp/Pages/RegisterPage.dart';
import 'package:mobileapp/Pages/AllQuranSurahsPage.dart';
import 'package:mobileapp/Pages/QuranicDuaPage.dart';
import 'package:mobileapp/Pages/QuranInfoCardsPage.dart';
import 'package:mobileapp/Pages/DuaaKhatmQuranPage.dart';
import 'package:mobileapp/Pages/SajdaAyahsPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale("ar"),
      // Locale("en") for English
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Jawed Ai',
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        ForgotPasswordPage.routeName: (context) => ForgotPasswordPage(),
        ResetPasswordPage.routeName: (context) => ResetPasswordPage(),
        AllQuranSurahsPage.routeName: (context) => AllQuranSurahsPage(),
        SurahListPage.routeName: (context) => SurahListPage(),
        SurahDetailPage.routeName: (context) => SurahDetailPage(),
        QuranicDuaPage.routeName: (context) => QuranicDuaPage(),
        QuranInfoCardsPage.routeName: (context) => QuranInfoCardsPage(),
        DuaaKhatmQuranPage.routeName: (context) => DuaaKhatmQuranPage(),
        SajdaAyahsPage.routeName: (context) => SajdaAyahsPage(),
        Ahkampage.routeName: (context) => Ahkampage(),
        HukmPage.routeName: (context) => HukmPage(),
      },
    );
  }
}