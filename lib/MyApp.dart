import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobileapp/Pages/ForgotPasswordPage.dart';
import 'package:mobileapp/Pages/GeminiChatPage.dart';
import 'package:mobileapp/Pages/ResetPasswordPage.dart';
import 'package:mobileapp/Pages/SurahDetailPage.dart';
import 'package:mobileapp/Pages/SurahListPage.dart';
import 'package:mobileapp/generated/l10n.dart';
import 'package:mobileapp/Pages/HomePage.dart';
import 'package:mobileapp/Pages/LoginPage.dart';
import 'package:mobileapp/Pages/RegisterPage.dart';
import 'package:mobileapp/Pages/AllQuranSurahsPage.dart';
import 'package:mobileapp/Pages/QuranicDuaPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale("ar"), // Locale("en") for English
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Jawed Ai',
      initialRoute: GeminiChatPage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(), // test done
        ForgotPasswordPage.routeName: (context) => ForgotPasswordPage(), // test done
        ResetPasswordPage.routeName: (_) => const ResetPasswordPage(), // test done
        AllQuranSurahsPage.routeName: (context) => const AllQuranSurahsPage(), // test done
        SurahListPage.routeName: (_) => const SurahListPage(), // test done
        SurahDetailPage.routeName: (_) => const SurahDetailPage(),
        QuranicDuaPage.routeName: (context) =>  QuranicDuaPage(), // test done
        GeminiChatPage.routeName: (_) => const GeminiChatPage()
      },
    );
  }
}