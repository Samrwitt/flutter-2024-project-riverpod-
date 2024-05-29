// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:digital_notebook/presentation/screens/home.dart';
import 'package:digital_notebook/presentation/screens/admin/admin.dart';
import 'package:digital_notebook/presentation/screens/admin/adminLogin.dart';
import 'package:digital_notebook/presentation/screens/admin/adminNotes.dart';
import 'package:digital_notebook/presentation/screens/admin/adminOthers.dart';
import 'package:digital_notebook/presentation/screens/login.dart';
import 'package:digital_notebook/presentation/screens/signup.dart';
import 'package:digital_notebook/presentation/screens/notes.dart';
import 'package:digital_notebook/presentation/screens/others.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ThemeModeOption {
  white,
  // ignore: constant_identifier_names
  Sepia,
  dark,
}

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeModeOption currentThemeMode = ThemeModeOption.white;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = buildThemeData();

    return MaterialApp(
      themeMode: currentThemeMode == ThemeModeOption.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: themeData,
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/admin': (context) => AdminPage(),
        '/other': (context) => ViewOtherNotesPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/notes': (context) => const Notepage(),
        '/adminLogin': (context) => const AdminLoginPage(),
        '/adminNotes': (context) => AdminNotepage(
          onNewNoteCreated: (note) {},
          currentIndex: 0,
        ),
        '/adminOthers': (context) => const AdminOthersPage(),
      },
    );
  }

  ThemeData buildThemeData() {
    switch (currentThemeMode) {
      case ThemeModeOption.white:
        return ThemeData.light().copyWith(
          textTheme: ThemeData.light().textTheme.copyWith(
            bodyLarge: const TextStyle(fontFamily: 'Mate'),
            bodyMedium: const TextStyle(fontFamily: 'Mate'),
          ),
        );
      case ThemeModeOption.Sepia:
        return ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 189, 148, 128), // Sepia color
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 189, 148, 128), // Sepia color
            titleTextStyle: TextStyle(color: Colors.grey, fontFamily: 'Mate'),
            iconTheme: IconThemeData(color: Colors.grey),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.grey, fontFamily: 'Mate'),
            bodyMedium: TextStyle(color: Colors.grey, fontFamily: 'Mate'),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white, fontFamily: 'Mate'),
            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Mate'),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 189, 148, 128), // Sepia color
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.grey,
          ),
          bottomAppBarTheme: const BottomAppBarTheme(color: Color.fromARGB(255, 189, 148, 128)), // Sepia color
        );
      case ThemeModeOption.dark:
        return ThemeData.dark().copyWith(
          textTheme: ThemeData.light().textTheme.copyWith(
            bodyLarge: const TextStyle(fontFamily: 'Mate'),
            bodyMedium: const TextStyle(fontFamily: 'Mate'),
          ),
        );
    }
  }

  void changeThemeMode(ThemeModeOption newThemeMode) {
    setState(() {
      currentThemeMode = newThemeMode;
    });
  }
}
