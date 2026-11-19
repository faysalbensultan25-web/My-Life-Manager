import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Life Manager',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('bn'), // Bangla
      ],
      theme: ThemeData(
        primaryColor: const Color(0xFF1877F2), // Facebook Blue
        scaffoldBackgroundColor: const Color(0xFFF0F2F5), // Facebook Light Gray
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1877F2),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF1877F2),
          unselectedItemColor: Color(0xFF65676B),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainNavigation(), // মেইন নেভিগেশন স্ক্রিন
    );
  }
}
