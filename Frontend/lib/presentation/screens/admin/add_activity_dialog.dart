import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';

class AddActivityDialog extends StatelessWidget {
  final TextEditingController userController;
  final TextEditingController activityController;
  final DateTime? selectedDateTime;
  final Function(String, String, DateTime) onAddActivity;
  final VoidCallback onCloseDialog;

  const AddActivityDialog({
    Key? key,
    required this.userController,
    required this.activityController,
    this.selectedDateTime,
    required this.onAddActivity,
    required this.onCloseDialog,
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
            onPressed: () async {
              final DateTime? pickedDateTime = await showDatePicker(
                context: context,
                initialDate: selectedDateTime ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDateTime != null) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
                );

                if (pickedTime != null) {
                  final DateTime finalDateTime = DateTime(
                    pickedDateTime.year,
                    pickedDateTime.month,
                    pickedDateTime.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  onAddActivity(userController.text, activityController.text, finalDateTime);
                  onCloseDialog();
                }
              }
            },
            child: const Text('Select Date and Time'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: onCloseDialog,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
