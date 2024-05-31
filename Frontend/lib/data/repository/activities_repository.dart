import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/models/activity_model.dart';
import 'package:digital_notebook/data/dataProvider/auth_provider.dart'; // Ensure the path is correct based on your project structure.

final activitiesRepositoryProvider = Provider<ActivitiesRepository>(
  (ref) => ActivitiesRepository(ref),
);

class ActivitiesRepository {
  ActivitiesRepository(this.ref);

  final Ref ref;
  final String _baseUrl = 'http://localhost:3000/logs'; 
  Future<Activity> addActivity(String user, String name, DateTime dateTime, String userRole) async {
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

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      return Activity.fromJson(responseBody);
    } else {
      throw Exception('Failed to add activity');
    }
  }

  Future<Activity> editActivity(Activity activity) async {
    final authProvider = ref.read(authProviderProvider);

    final response = await http.patch(
      Uri.parse('$_baseUrl/${activity.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authProvider.authToken}',
      },
      body: jsonEncode(activity.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return Activity.fromJson(responseBody);
    } else {
      throw Exception('Failed to edit activity');
    }
  }

  Future<void> deleteActivity(String id) async {
    final authProvider = ref.read(authProviderProvider);

    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authProvider.authToken}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity');
    }
  }

  Future<List<Activity>> fetchActivities() async {
    final authProvider = ref.read(authProviderProvider);

    if (authProvider == null || authProvider.authToken == null || authProvider.authToken!.isEmpty) {
      throw Exception('AuthToken is invalid');
    }

    final response = await http.get(Uri.parse('$_baseUrl'), headers: {
      'Authorization': 'Bearer ${authProvider.authToken}',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((activity) => Activity.fromJson(activity)).toList();
    } else {
      throw Exception('Failed to load activities. Status code: ${response.statusCode}');
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
