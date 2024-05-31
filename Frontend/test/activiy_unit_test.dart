import 'package:digital_notebook/domain/models/activity_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivitiesNotifier Unit Tests', () {
    test('Activity is formatted correctly', () {
      final activity = Activity(
        user: 'testUser',
        name: 'Test Activity',
        date: '2024-06-01',
        time: '12:00',
        logs: [],
        id: '1'
      );

      expect(activity.date, '2024-06-01');
      expect(activity.time, '12:00');
    });
  });
}