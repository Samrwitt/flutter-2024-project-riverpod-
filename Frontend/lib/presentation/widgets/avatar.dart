import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:digital_notebook/providers/navigatorkey_provider.dart";

// Provider for handling the logout functionality
final logoutProvider = Provider.autoDispose((ref) {
  return () {
    ref.read(navigatorKeyProvider).currentState?.pushReplacementNamed('/login');
  };
});

class CircleAvatarWidget extends ConsumerWidget {
  const CircleAvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logout = ref.watch(logoutProvider);

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'logout',
            child: Text('Logout'),
          ),
        ];
      },
      onSelected: (String value) {
        if (value == 'logout') {
          logout(); // Call the logout function provided by the provider
        }
      },
      child: const CircleAvatar(
        backgroundImage: AssetImage('assets/images/avatar.png'),
      ),
    );
  }
}