import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
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
import 'package:digital_notebook/data/dataProvider/navigatorkey_provider.dart';
import 'package:digital_notebook/data/dataProvider/auth_provider.dart'; // Import the auth provider
import 'package:digital_notebook/data/dataProvider/notes_provider.dart'; // Import the notes provider
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final httpProvider = Provider<http.Client>((ref) {
  return http.Client();
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
          ),
        
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
        GoRoute(
          path: '/notes',
          builder: (context, state) {
            final user = ref.watch(authProviderProvider).currentUser;
            return user != null && user.id.isNotEmpty
                ? Notepage(userId: user.id)
                : const LoginPage();
          },
        ),
        GoRoute(
          path: '/addNote',
          builder: (context, state) {
            final user = ref.watch(authProviderProvider).currentUser;
            return user != null && user.id.isNotEmpty
                ? AddNote(
                    userId: user.id,
                    currentIndex: 0,
                    onNewNoteCreated: (note) {},
                  )
                : const LoginPage();
          },
        ),
        GoRoute(path: '/admin', builder: (context, state) { final user = ref.watch(authProviderProvider).currentUser;
            return user != null && user.id.isNotEmpty
                ? AdminPage(userId: user.id)
                :const AdminLogin();
  },
  ),
        GoRoute(path: '/adminLogin', builder: (context, state) => const AdminLogin()),
        GoRoute(
  path: '/adminNotes',
  builder: (context, state) {
                final user = ref.watch(authProviderProvider).currentUser;
            return user != null && user.id.isNotEmpty
                ? AdminNotepage(userId: user.id)
      : const AdminLogin();
    },
         ),
  
        GoRoute(path: '/adminOthers', builder: (context, state) => const AdminOthersPage()),
        GoRoute(path: '/updateProfile', builder: (context, state) => const UpdateProfilePage()),
        GoRoute(path: '/manageUsers', builder: (context, state) => ManageUsersPage()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigatorKey = ref.watch(navigatorKeyProvider);

    return MaterialApp.router(
      routerConfig: _router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}


// AuthCheck widget to manage authentication state
class AuthCheck extends ConsumerWidget {
  final Widget onAuthenticated;

  AuthCheck({required this.onAuthenticated});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.watch(authProviderProvider);

    if (authProvider.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (authProvider.authToken == null) {
      return LoginPage();
    } else {
      return onAuthenticated;
    }
  }
}
