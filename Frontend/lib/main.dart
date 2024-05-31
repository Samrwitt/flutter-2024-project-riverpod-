import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_notebook/presentation/screens/home.dart';
import 'package:digital_notebook/presentation/screens/admin/admin.dart';
import 'package:digital_notebook/presentation/screens/admin/manage_users.dart';
import 'package:digital_notebook/presentation/screens/admin/adminLogin.dart';
import 'package:digital_notebook/presentation/screens/admin/adminNotes.dart';
import 'package:digital_notebook/presentation/screens/admin/adminOthers.dart';
import 'package:digital_notebook/presentation/screens/login.dart';
import 'package:digital_notebook/presentation/screens/signup.dart';
import 'package:digital_notebook/presentation/screens/notes.dart';
import 'package:digital_notebook/presentation/screens/addnotes.dart';
import 'package:digital_notebook/presentation/screens/update_profile.dart';
import 'package:digital_notebook/providers/navigatorkey_provider.dart';
import 'package:digital_notebook/providers/user_provider.dart'
    as user_prov; // Use alias to avoid ambiguity

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ThemeModeOption currentThemeMode = ThemeModeOption.white;

  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
            path: '/signup', builder: (context, state) => const SignupPage()),
        GoRoute(
            path: '/notes',
            builder: (context, state) => const Notepage(
                  userId: '',
                )),
        GoRoute(
          path: '/addNote',
          builder: (context, state) {
            final user = ref.read(user_prov.userProvider);
            return user.id.isNotEmpty
                ? AddNote(
                    userId: user.id,
                    currentIndex: 0,
                    onNewNoteCreated: (Note) {},
                  )
                : const LoginPage();
          },
        ),
        GoRoute(path: '/admin', builder: (context, state) => const AdminPage()),
        GoRoute(
            path: '/adminLogin',
            builder: (context, state) => const AdminLoginPage()),
        GoRoute(
          path: '/adminNotes',
          builder: (context, state) {
            final user = ref.read(user_prov.userProvider);
            return user.id.isNotEmpty
                ? AdminNotepage(userId: user.id, currentIndex: 0)
                : const LoginPage();
          },
        ),
        GoRoute(
            path: '/adminOthers',
            builder: (context, state) => const AdminOthersPage()),
        GoRoute(
            path: '/updateProfile',
            builder: (context, state) => const UpdateProfilePage()),
        GoRoute(
            path: '/manageUsers',
            builder: (context, state) => const ManageUsersPage()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigatorKey = ref.watch(navigatorKeyProvider);
    final ThemeData themeData = _buildThemeData(currentThemeMode);

    return MaterialApp.router(
      routerConfig: _router,
      themeMode: currentThemeMode == ThemeModeOption.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: themeData,
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }

  ThemeData _buildThemeData(ThemeModeOption mode) {
    switch (mode) {
      case ThemeModeOption.white:
        return ThemeData.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Mate'),
        );
      case ThemeModeOption.sepia:
        return ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 189, 148, 128),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 189, 148, 128),
            titleTextStyle: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontFamily: 'Mate'),
          ),
          textTheme: ThemeData.light().textTheme.apply(
                fontFamily: 'Mate',
                bodyColor: const Color.fromARGB(255, 0, 0, 0),
                displayColor: const Color.fromARGB(255, 0, 0, 0),
              ),
        );
      case ThemeModeOption.dark:
        return ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Mate'),
        );
      default:
        return ThemeData.light();
    }
  }
}

enum ThemeModeOption {
  white,
  sepia,
  dark,
}
