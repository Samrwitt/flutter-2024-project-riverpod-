import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddActivityDialog extends StatelessWidget {
  final TextEditingController userController;
  final TextEditingController activityController;
  final DateTime selectedDateTime;
  final Function(String, String, DateTime) onAddActivity;

  const AddActivityDialog({
    Key? key,
    required this.userController,
    required this.activityController,
    required this.selectedDateTime,
    required this.onAddActivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Activity'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: userController,
            decoration: const InputDecoration(labelText: 'User'),
          ),
          TextField(
            controller: activityController,
            decoration: const InputDecoration(labelText: 'Activity'),
          ),
          ElevatedButton(
            onPressed: () => _selectDateTime(context),
            child: const Text('Select Date and Time'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onAddActivity(userController.text, activityController.text, selectedDateTime);
            context.pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onAddActivity(userController.text, activityController.text, finalDateTime);
        context.pop();
      }
    }
  }
}
