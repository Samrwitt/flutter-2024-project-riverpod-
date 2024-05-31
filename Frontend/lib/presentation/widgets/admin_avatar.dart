import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_notebook/application/providers/navigatorkey_provider.dart';
import 'package:digital_notebook/application/providers/logout_provider.dart';
import 'package:digital_notebook/application/providers/manage_users_provider.dart';

// Provider for handling the logout functionality
final logoutProvider = Provider.autoDispose<void Function(BuildContext)>((ref) {
  return (BuildContext context) {
    context.go('/'); // Assuming '/' is the route to logout and redirect to
  };
});

class AdminCircleAvatarWidget extends ConsumerWidget {
  const AdminCircleAvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logout = ref.watch(logoutProvider);

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'admin',
            child: Text(
              'Admin',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            enabled: false, // This item is just a display for the admin name
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'manageUsers',
            child: Text('Manage Users'),
          ),
          const PopupMenuItem<String>(
            value: 'logout',
            child: Text('Logout'),
          ),
        ];
      },
      onSelected: (String value) {
        switch (value) {
          case 'manageUsers':
            context.go('/manageUsers'); // Navigate using GoRouter
            break;
          case 'logout':
            logout(
                context); // Execute logout function which uses GoRouter to navigate
            break;
        }
      },
      child: const CircleAvatar(
        backgroundImage: AssetImage(
            'assets/images/avatar.png'), // Ensure this asset is correctly placed in your assets directory
      ),
    );
  }
}
