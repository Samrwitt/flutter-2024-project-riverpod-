import 'package:flutter/material.dart';
import './add_activity_dialog.dart';
import './adminOthers.dart';
import './adminNotes.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> with SingleTickerProviderStateMixin {
  List<Activity> activities = [];
  TextEditingController activityController = TextEditingController();
  TextEditingController userController = TextEditingController();
  DateTime? _selectedDateTime;
  late TabController _tabController; // Define TabController

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Initialize TabController
    _tabController.addListener(_handleTabSelection); // Add listener for tab selection
  }

  void _handleTabSelection() {
    setState(() {}); // Update the state when a tab is selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin', style: TextStyle(fontSize: 25) ,),
      ),
      body: TabBarView(
        controller: _tabController, // Assign TabController to TabBarView
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
                      'User: ${activities[index].user}, Date: ${activities[index].date}, Time: ${activities[index].time}'),
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
                            _deleteActivity(index);
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
          AdminNotepage(onNewNoteCreated: (note) {
            //do Nothing
            },
            currentIndex: 0,
            ),
          // Other People page content
          const AdminOthersPage(),
        ],
      ),
      floatingActionButton: _tabController.index == 0 // Show FAB only on the home page
          ? FloatingActionButton(
              onPressed: () {
                _showAddActivityDialog(context);
              }, backgroundColor: Colors.blueGrey,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: TabBar(
        controller: _tabController, // Assign TabController to TabBar
        tabs: const [
          Tab(icon: Icon(Icons.history, color:Colors.blueGrey), text: 'History',), // Current page
          Tab(icon: Icon(Icons.notes, color:Colors.blueGrey), text: 'Notes',), // Notes page
          Tab(icon: Icon(Icons.people_alt, color:Colors.blueGrey), text: "Other's Notes",), // Other People page
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
    setState(() {
      activities.add(Activity(
        user: user,
        name: activityName,
        date: '${dateTime.year}-${dateTime.month}-${dateTime.day}',
        time: '${dateTime.hour}:${dateTime.minute}',
        logs: ['Added at ${DateTime.now()}'], // Log entry for adding the activity
      ));
    });
  }

  void _showEditActivityDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: activities[index].user),
                decoration: const InputDecoration(
                  labelText: 'User'
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                ),
              ),
              TextField(
                controller: TextEditingController(text: activities[index].name),
                decoration: const InputDecoration(
                  labelText: 'Activity',
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editActivity(index, userController.text, activityController.text);
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

  void _editActivity(int index, String newUser, String newName) {
    setState(() {
      var editedActivity = activities[index];
      editedActivity.user = newUser;
      editedActivity.name = newName;
      editedActivity.logs.add('Edited at ${DateTime.now()}'); // Log entry for editing the activity
    });
  }

  void _deleteActivity(int index) {
    setState(() {
      var deletedActivity = activities[index];
      deletedActivity.logs.add('Deleted at ${DateTime.now()}'); // Log entry for deleting the activity
      activities.removeAt(index);
    });
  }
}

class Activity {
  String user;
  String name;
  String date;
  String time;
  List<String> logs;

  Activity({required this.user, required this.name, required this.date, required this.time, this.logs = const []});
}
