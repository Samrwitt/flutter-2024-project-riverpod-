import 'package:digital_notebook/data/dataProvider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_notebook/data/dataProvider/user_provider.dart';

final updateProfileProvider = Provider.autoDispose<void Function(BuildContext)>((ref) {
  return (BuildContext context) {
    context.go('/updateProfile'); // Navigating using GoRouter
  };
});

class CircleAvatarWidget extends ConsumerWidget {
  const CircleAvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.read(authProviderProvider);
    final updateProfile = ref.read(updateProfileProvider);
    final user = ref.watch(userProvider);

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'email',
            child: Text(
              user?.email ?? 'No Email', // Accessing the email directly from user
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
            updateProfile(context);
            break;
          case 'deleteAccount':
            _confirmDeleteAccount(context, authProvider);
            break;
          case 'logout':
            authProvider.logout();
            break;
        }
      },
      child: CircleAvatar(
        backgroundImage: AssetImage(
          'assets/images/avatar.png', // Ensure this asset is correctly placed in your assets directory
        ),
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                authProvider.deleteAccount();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
