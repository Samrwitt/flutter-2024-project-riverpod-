import 'package:flutter/material.dart';

class AddActivityDialog extends StatefulWidget {
  final TextEditingController userController;
  final TextEditingController activityController;
  final DateTime? selectedDateTime;
  final Function(String, String, DateTime) onAddActivity;
  final VoidCallback onCloseDialog;

  const AddActivityDialog({super.key,
    required this.userController,
    required this.activityController,
    required this.selectedDateTime,
    required this.onAddActivity,
    required this.onCloseDialog,
  });

  @override
  AddActivityDialogState createState() => AddActivityDialogState();
}

class AddActivityDialogState extends State<AddActivityDialog> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    _selectedDateTime = widget.selectedDateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: widget.userController,
              decoration: const InputDecoration(
                labelText: 'User',
            ),
            style: const TextStyle(
                  color: Colors.black,
                ),
            ),
            TextField(
              controller: widget.activityController,
              decoration: const InputDecoration(labelText: 'Activity'),
            style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text(_selectedDateTime == null
                  ? 'Select Date and Time'
                  : 'Date and Time: ${_selectedDateTime!.toString().substring(0, 16)}', style:const TextStyle(color: Colors.blueGrey)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_validateInputs()) {
                      widget.onAddActivity(
                        widget.userController.text,
                        widget.activityController.text,
                        _selectedDateTime ?? DateTime.now(),
                      );
                      widget.onCloseDialog();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Add', style:TextStyle(color: Colors.blueGrey)),
                ),
                ElevatedButton(
                  onPressed: widget.onCloseDialog,
                  child: const Text('Cancel', style:TextStyle(color: Colors.blueGrey)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  bool _validateInputs() {
    return widget.userController.text.isNotEmpty &&
        widget.activityController.text.isNotEmpty &&
        _selectedDateTime != null;
  }
}
