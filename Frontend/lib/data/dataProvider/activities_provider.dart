import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/models/activity_model.dart';
import 'package:digital_notebook/data/dataProvider/auth_provider.dart'; // Ensure the path is correct based on your project structure.

final activitiesProvider = StateNotifierProvider<ActivitiesNotifier, List<Activity>>(
  (ref) => ActivitiesNotifier(ref),
);

class ActivitiesNotifier extends StateNotifier<List<Activity>> {
  ActivitiesNotifier(this.ref) : super([]);

  final Ref ref;
  final String _baseUrl = 'http://localhost:3000/logs'; 

  Future<void> addActivity(String user, String name, DateTime dateTime, String userRole) async {
    print('Adding activity: $user, $name, $dateTime, $userRole');

    final activity = Activity(
      user: user,
      name: name,
      date: '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      time: '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
      logs: ['Added at ${DateTime.now()}'],
      id: null, // Ensure id is null for new entries
    );

    final authProvider = ref.read(authProviderProvider);

    final response = await http.post(
      Uri.parse('$_baseUrl'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authProvider.authToken}',
      },
      body: jsonEncode(activity.toJson()),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      final createdActivity = Activity.fromJson(responseBody);

      state = [...state, createdActivity];
      print('Activity added successfully');
    } else {
      throw Exception('Failed to add activity');
    }
  }

  Future<void> editActivity(int index, String user, String name, DateTime dateTime, String userRole) async {
    Activity editedActivity; // Declare editedActivity outside try-catch block

    try {
      editedActivity = state[index].copyWith(
        user: user,
        name: name,
        date: '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
        time: '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
        logs: [
          ...state[index].logs,
          'Edited at ${DateTime.now()}',
        ],
      );
    } catch (e) {
      // Handle any errors here, e.g., log them or show an error message
      print('Error editing activity locally: $e');
      throw Exception('Failed to edit activity locally');
    }

    final authProvider = ref.read(authProviderProvider);

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/${state[index].id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.authToken}',
        },
        body: jsonEncode(editedActivity.toJson()),
      );

      if (response.statusCode == 200) {
        // Update state only after successful HTTP request
        state = [
          ...state.sublist(0, index),  // Keep items before the edited one
          editedActivity,             // Replace edited item with updated one
          ...state.sublist(index + 1), // Keep items after the edited one
        ];
      } else {
        throw Exception('Failed to edit activity on server');
      }
    } catch (e) {
      // Handle any errors from the HTTP request
      print('Error editing activity on server: $e');
      throw Exception('Failed to edit activity on server');
    }
  }

  Future<void> deleteActivity(int index, String id) async {
    final authProvider = ref.read(authProviderProvider);

final response = await http.delete(
      Uri.parse('$_baseUrl/${state[index].id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authProvider.authToken}',
      },
    );

    if (response.statusCode == 200) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i != index) state[i],
      ];
    } else {
      throw Exception('Failed to delete activity');
    }
  }

  Future<void> fetchActivities() async {
    try {
      final authProvider = ref.read(authProviderProvider);

      // Check if authProvider or authToken is null
      if (authProvider == null) {
        throw Exception('AuthProvider is null');
      }
      if (authProvider.authToken == null) {
        throw Exception('AuthToken is null');
      }

      // Check if authToken is empty
      if (authProvider.authToken!.isEmpty) {
        throw Exception('AuthToken is empty');
      }

      final response = await http.get(Uri.parse('$_baseUrl'), headers: {
        'Authorization': 'Bearer ${authProvider.authToken}',
      });

      if (response.statusCode == 200) {
        // Check if response body is null or empty
        if (response.body == null || response.body.isEmpty) {
          throw Exception('Response body is empty');
        }

        final List<dynamic> data = jsonDecode(response.body);
        state = data.map((activity) => Activity.fromJson(activity)).toList();
      } else {
        throw Exception('Failed to load activities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities: $e');
      throw Exception('Failed to fetch activities');
    }
  }

  Future<Activity> getActivity(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Activity.fromJson(data);
    } else {
      throw Exception('Failed to load activity');
    }
  }
}