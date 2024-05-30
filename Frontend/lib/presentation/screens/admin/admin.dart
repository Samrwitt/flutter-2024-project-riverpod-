import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_activity_dialog.dart';
import 'adminOthers.dart';
import 'adminNotes.dart';
import '../../widgets/admin_avatar.dart';
import '../../../providers/activities_provider.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> with SingleTickerProviderStateMixin {
  TextEditingController activityController = TextEditingController();
  TextEditingController userController = TextEditingController();
  DateTime? _selectedDateTime;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(activitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin', style: TextStyle(fontSize: 25)), actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/adminlogin');
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: AdminCircleAvatarWidget(),
                  ),
                ),
              ),
            ),
          ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Current page content (AdminHomePage)
          ListView.builder(
            itemCount: activities.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(activities[index].name),
                    subtitle: Text(
                      'User: ${activities[index].user}, Date: ${activities[index].date}, Time: ${activities[index].time}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditActivityDialog(context, index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            ref.read(activitiesProvider.notifier).deleteActivity(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (activities[index].logs.isNotEmpty) ...[
                    const Text(
                      'Logs:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: activities[index]
                          .logs
                          .map((log) => Text(
                                log,
                                textAlign: TextAlign.center,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const Divider(),
                ],
              );
            },
          ),
          // Notes page content
          AdminNotepage(
            onNewNoteCreated: (note) {
              // do Nothing
            },
            currentIndex: 0,
          ),
          // Other People page content
          const AdminOthersPage(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () {
                _showAddActivityDialog(context);
              },
              backgroundColor: Colors.blueGrey,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.history, color: Colors.blueGrey), text: 'History'),
          Tab(icon: Icon(Icons.notes, color: Colors.blueGrey), text: 'Notes'),
          Tab(icon: Icon(Icons.people_alt, color: Colors.blueGrey), text: "Other's Notes"),
        ],
      ),
    );
  }

  void _showAddActivityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddActivityDialog(
          userController: userController,
          activityController: activityController,
          selectedDateTime: _selectedDateTime,
          onAddActivity: (user, activity, dateTime) {
            _addActivity(user, activity, dateTime);
          },
          onCloseDialog: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _addActivity(String user, String activityName, DateTime dateTime) {
    ref.read(activitiesProvider.notifier).addActivity(user, activityName, dateTime);
  }

  void _showEditActivityDialog(BuildContext context, int index) {
    final editUserController = TextEditingController(text: ref.read(activitiesProvider)[index].user);
    final editActivityController = TextEditingController(text: ref.read(activitiesProvider)[index].name);
    DateTime selectedEditDateTime = DateTime.parse('${ref.read(activitiesProvider)[index].date} ${ref.read(activitiesProvider)[index].time.padLeft(5, '0')}:00');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editUserController,
                decoration: const InputDecoration(labelText: 'User'),
                style: const TextStyle(color: Colors.black),
              ),
              TextField(
                controller: editActivityController,
                decoration: const InputDecoration(labelText: 'Activity'),
                style: const TextStyle(color: Colors.black),
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
                      initialTime: TimeOfDay.fromDateTime(selectedEditDateTime),
                    );

                    if (pickedTime != null) {
                      selectedEditDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
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
  }

  void _editActivity(int index, String newUser, String newName, DateTime newDateTime) {
    ref.read(activitiesProvider.notifier).editActivity(
      index,
      newUser,
      newName,
      newDateTime,
    );
  }
}
