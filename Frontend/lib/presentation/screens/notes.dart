import 'package:flutter/material.dart';
import './addnotes.dart';
import 'package:digital_notebook/models/note_model.dart';
import 'package:digital_notebook/presentation/widgets/note_card.dart';
import '../widgets/avatar.dart';
import './others.dart';

class Notepage extends StatefulWidget {
  const Notepage({super.key});


  @override
  State<Notepage> createState() => NotepageState();
}


class NotepageState extends State<Notepage> with SingleTickerProviderStateMixin {
  List<Note> notes = List.empty(growable: true);
  late TabController _tabController;

  @override
@override
void initState() {
  super.initState();
  _tabController = TabController(length: 2, vsync: this);
  _tabController.addListener(() {
    setState(() {});
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child:  Text(
            'Notes',
            style: TextStyle(
              fontSize: 28,
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: CircleAvatarWidget(key: Key('avatar')),
                ),
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return NotesCard(note: notes[index], index: index, onNoteDeleted: onNoteDeleted, onNoteEdited: onNoteEdited,);
            },
          ),
            const ViewOtherNotesPage(),
        ],
      ),
      bottomNavigationBar: TabBar(
      controller: _tabController,
      onTap: (index) {
        _tabController.animateTo(index);
      },
tabs: const [
  Tab(icon: Icon(Icons.notes), text: "Notes"),
  Tab(icon: Icon(Icons.people_alt), text: "Other's Notes"),
],
      ),
    floatingActionButton: _tabController.index == 0
    ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddNote(
                      onNewNoteCreated: onNewNoteCreated,
                      currentIndex: notes.length,
                    )),
          );
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      )
    : null,
    );
  }
  void onNewNoteCreated(Note note){
    notes.add(note);
    setState((){});
    }

  void onNoteDeleted(int index){
    notes.removeAt(index);
    setState(() {});
  }
void onNoteEdited(Note note) {
  notes[note.index].title = note.title;
  notes[note.index].body = note.body;
  setState(() {});
}
}