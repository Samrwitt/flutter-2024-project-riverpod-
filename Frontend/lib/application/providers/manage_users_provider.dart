import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/data/models/user_model.dart'; // Import your User model

// Simulated user data
final List<User> _dummyUsers = [
  User(id: '1', name: 'User1', email: 'user1@example.com'),
  User(id: '2', name: 'User2', email: 'user2@example.com'),
];

// StateNotifier for managing users
class ManageUsersNotifier extends StateNotifier<AsyncValue<List<User>>> {
  ManageUsersNotifier() : super(const AsyncValue.loading()) {
    loadUsers();
  }

  void loadUsers() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));
    state = AsyncValue.data(_dummyUsers);
  }

  void addUser(User user) {
    state.whenData((users) => state = AsyncValue.data([...users, user]));
  }

  void deleteUser(String userId) {
    state.whenData((users) => state =
        AsyncValue.data(users.where((user) => user.id != userId).toList()));
  }

  void updateUser(User updatedUser) {
    state.whenData((users) {
      final index = users.indexWhere((user) => user.id == updatedUser.id);
      final updatedUsers = List<User>.from(users);
      if (index != -1) {
        updatedUsers[index] = updatedUser;
        state = AsyncValue.data(updatedUsers);
      }
    });
  }
}

final manageUsersProvider =
    StateNotifierProvider<ManageUsersNotifier, AsyncValue<List<User>>>((ref) {
  return ManageUsersNotifier();
});
