import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/providers/navigatorkey_provider.dart';
import 'package:digital_notebook/providers/logout_provider.dart';
import 'package:digital_notebook/providers/manage_users_provider.dart'; // Import the provider for managing users

// Provider for handling the logout functionality for admin
final LogoutProvider = Provider.autoDispose((ref) {
  return () {
    ref.read(navigatorKeyProvider).currentState?.pushReplacementNamed('/');
  };
});

class AdminCircleAvatarWidget extends ConsumerWidget {
  const AdminCircleAvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Logout = ref.watch(LogoutProvider);
    final manageUsers = ref.watch(manageUsersProvider);

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'admin',
            child: Text(
              'Admin',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            enabled: false, // This item is just a display for the admin name
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'manageUsers',
            child: Text('Manage Users'),
          ),
          const PopupMenuItem<String>(
            value: 'Logout',
            child: Text('Logout'),
          ),
        ];
      },
      onSelected: (String value) {
        switch (value) {
          case 'manageUsers':
            Navigator.pushNamed(context, '/manageUsers');
            break;
          case 'Logout':
            Logout();
            break;
        }
      },
      child: const CircleAvatar(
        backgroundImage: AssetImage('assets/images/avatar.png'), // Replace with admin avatar image
      ),
    );
  }
}
