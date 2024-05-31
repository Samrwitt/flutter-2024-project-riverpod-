import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';
import 'dart:convert'; // Import for json.decode
import 'package:digital_notebook/domain/models/user_model.dart'; // Import your User model

final manageUsersProvider = StateNotifierProvider<ManageUsersNotifier, AsyncValue<List<User>>>((ref) {
  return ManageUsersNotifier(ref);
});

class ManageUsersNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final StateNotifierProviderRef<ManageUsersNotifier, AsyncValue<List<User>>> _ref;

  ManageUsersNotifier(this._ref) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final token = await _ref.read(authProviderProvider).authToken;
      if (token != null) {
        print('Token: $token');
        await loadUsers(token);
      } else {
        print('Auth token is null');
      }
    } catch (e) {
      print('Failed to initialize notes: $e');
    }
  }

  Future<void> loadUsers(String token) async {
    try {
      print('Loading users...');
      final response = await http.get(
        Uri.parse('http://localhost:3000/admin/users'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<User> users = jsonData.map((json) => User.fromJson(json)).toList();
        print('Loaded users: $users');
        state = AsyncValue.data(users);
      } else {
        print('Failed to load users. Status code: ${response.statusCode}');
        state = AsyncValue.error('Failed to load users', StackTrace.current);
      }
    } catch (e) {
      print('Error loading users: $e');
      state = AsyncValue.error('Error: $e', StackTrace.current);
    }
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
