import 'package:digital_notebook/data/models/activity_model.dart';
import 'package:digital_notebook/presentation/widgets/admin_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_notebook/application/providers/activities_provider.dart';
import 'add_activity_dialog.dart';
import 'adminOthers.dart';
import 'adminNotes.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(activitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          const AdminCircleAvatarWidget(), // Using the avatar widget
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivitiesList(context, activities),
          const AdminNotepage(currentIndex: 0, userId: 'specified-user-id'),
          const AdminOthersPage(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => _showAddActivityDialog(context),
              backgroundColor: Color.fromARGB(255, 76, 109, 125),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.history), text: 'Activities'),
            Tab(icon: Icon(Icons.note), text: 'Notes'),
            Tab(icon: Icon(Icons.people), text: "Other's Notes"),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesList(BuildContext context, List<Activity> activities) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return ListTile(
          title: Text(activity.name),
          subtitle: Text(
              'User: ${activity.user}, Date: ${activity.date}, Time: ${activity.time}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditActivityDialog(context, index),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () =>
                    ref.read(activitiesProvider.notifier).deleteActivity(index),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddActivityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddActivityDialog(
          userController: TextEditingController(),
          activityController: TextEditingController(),
          selectedDateTime: DateTime.now(),
          onAddActivity: (String user, String activity, DateTime dateTime) {
            ref
                .read(activitiesProvider.notifier)
                .addActivity(user, activity, dateTime);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showEditActivityDialog(BuildContext context, int index) {
    final activity = ref.read(activitiesProvider)[index];
    final editUserController = TextEditingController(text: activity.user);
    final editActivityController = TextEditingController(text: activity.name);
    DateTime selectedEditDateTime;
    try {
      selectedEditDateTime = DateTime.parse(
          '${activity.date} ${activity.time.padLeft(5, '0')}:00');
    } catch (e) {
      selectedEditDateTime = DateTime.now();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Edit Activity'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editUserController,
                    decoration: const InputDecoration(labelText: 'User'),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  TextField(
                    controller: editActivityController,
                    decoration: const InputDecoration(labelText: 'Activity'),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedEditDateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay.fromDateTime(selectedEditDateTime),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            selectedEditDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    child: const Text('Select Date and Time'),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _editActivity(
                      index,
                      editUserController.text,
                      editActivityController.text,
                      selectedEditDateTime,
                    );
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editActivity(
      int index, String newUser, String newName, DateTime newDateTime) {
    ref.read(activitiesProvider.notifier).editActivity(
          index,
          newUser,
          newName,
          newDateTime,
        );
  }
}
