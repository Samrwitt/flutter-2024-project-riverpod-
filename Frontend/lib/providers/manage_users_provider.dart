import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/models/user_model.dart';

// Simulated user data
List<User> _dummyUsers = [
  User(username: 'User1', email: 'user1@example.com', password: 'password123'),
  User(username: 'User2', email: 'user2@example.com', password: 'password123'),
  // Add more users as needed
];

// StateNotifier for managing users
class ManageUsersNotifier extends StateNotifier<AsyncValue<List<User>>> {
  ManageUsersNotifier() : super(const AsyncValue.loading()) {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      state = AsyncValue.data(_dummyUsers);
    } catch (e, StackTrace) {
      state = AsyncValue.error(e, StackTrace);
    }
  }

  void deleteUser(User user) {
    final currentUsers = state.asData?.value ?? [];
    state = AsyncValue.data(currentUsers.where((u) => u != user).toList());
  }
}

final manageUsersProvider = StateNotifierProvider<ManageUsersNotifier, AsyncValue<List<User>>>((ref) {
  return ManageUsersNotifier();
});
