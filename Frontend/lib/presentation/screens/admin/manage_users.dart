import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_notebook/data/dataProvider/logout_provider.dart';
import 'package:digital_notebook/data/dataProvider/manage_users_provider.dart';

class ManageUsersPage extends ConsumerWidget {
  const ManageUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsyncValue = ref.watch(manageUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          IconButton(
            onPressed: () => context.go('/logout'), // Using GoRouter for navigation
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: usersAsyncValue.when(
        data: (users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, index) => ListTile(
            title: Text(users[index].email),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDeleteUser(context, users[index].id, ref),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, String userId, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(), // Close the dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(manageUsersProvider.notifier).deleteUser(userId);
              context.pop(); // Close the dialog
              _showDeletionSnackbar(context); // Show a snackbar notification
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeletionSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User deleted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
