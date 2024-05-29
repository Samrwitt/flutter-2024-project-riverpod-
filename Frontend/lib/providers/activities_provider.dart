import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note_model.dart';

final activitiesProvider = StateNotifierProvider<ActivitiesNotifier, List<Activity>>((ref) => ActivitiesNotifier());

class ActivitiesNotifier extends StateNotifier<List<Activity>> {
  ActivitiesNotifier() : super([]);

  void addActivity(String user, String name, DateTime dateTime) {
    final activity = Activity(
      user: user,
      name: name,
      date: '${dateTime.year}-${dateTime.month}-${dateTime.day}',
      time: '${dateTime.hour}:${dateTime.minute}',
      logs: ['Added at ${DateTime.now()}'],
    );
    state = [...state, activity];
  }

  void editActivity(int index, String newUser, String newName, DateTime newDateTime) {
    final editedActivity = state[index].copyWith(
      user: newUser,
      name: newName,
      date: '${newDateTime.year}-${newDateTime.month}-${newDateTime.day}',
      time: '${newDateTime.hour}:${newDateTime.minute}',
      logs: [
        ...state[index].logs,
        'Edited at ${DateTime.now()}',
      ],
    );

    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) editedActivity else state[i],
    ];
  }

  void deleteActivity(int index) {
    final updatedActivity = state[index].copyWith(
      logs: [
        ...state[index].logs,
        'Deleted at ${DateTime.now()}',
      ],
    );

    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i] else updatedActivity,
    ];

    // After adding the delete log, remove the activity
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }
}