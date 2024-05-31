import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/providers/navigatorkey_provider.dart';
//import 'package:digital_notebook/providers/logout_provider.dart';
import 'package:digital_notebook/providers/user_provider.dart';

// Provider for handling the logout functionality
final logoutProvider = Provider.autoDispose((ref) {
  return () {
    ref.read(navigatorKeyProvider).currentState?.pushReplacementNamed('/');
  };
});

// Provider for handling the delete account functionality
final deleteAccountProvider = Provider.autoDispose((ref) {
  return () {
    // Implement your delete account logic here
    ref.read(navigatorKeyProvider).currentState?.pushReplacementNamed('/');
  };
});

// Provider for handling the update profile functionality
final updateProfileProvider = Provider.autoDispose((ref) {
  return () {
    // Implement your update profile logic here
    ref.read(navigatorKeyProvider).currentState?.pushNamed('/updateProfile');
  };
});

class CircleAvatarWidget extends ConsumerWidget {
  const CircleAvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logout = ref.watch(logoutProvider);
    final deleteAccount = ref.watch(deleteAccountProvider);
    final updateProfile = ref.watch(updateProfileProvider);
    final user = ref.watch(userProvider);

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'email',
            child: Text(
              user.email,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            enabled: false, // This item is just a display for the email
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'updateProfile',
            child: Text('Update Profile'),
          ),
          const PopupMenuItem<String>(
            value: 'deleteAccount',
            child: Text('Delete Account'),
          ),
          const PopupMenuItem<String>(
            value: 'logout',
            child: Text('Logout'),
          ),
        ];
      },
      onSelected: (String value) {
        switch (value) {
          case 'updateProfile':
            updateProfile();
            break;
          case 'deleteAccount':
            deleteAccount();
            break;
          case 'logout':
            logout();
            break;
        }
      },
      child: const CircleAvatar(
        backgroundImage: AssetImage('assets/images/avatar.png'),
      ),
    );
  }
}
