import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/note_model.dart';
import '../../application/providers/notes_provider.dart' as providers;
import '../widgets/note_card.dart';
import 'others.dart' as others;
import 'package:digital_notebook/presentation/widgets/avatar.dart';

class Notepage extends ConsumerStatefulWidget {
  final String userId;

  const Notepage({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<Notepage> createState() => _NotepageState();
}

class _NotepageState extends ConsumerState<Notepage> {
  bool isAddingNote = false;
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Your Notes',
      style: TextStyle(fontSize: 24),
    ),
    Text(
      "Other's Notes",
      style: TextStyle(fontSize: 24),
    ),
  ];

  void toggleAddNote() {
    setState(() {
      isAddingNote = !isAddingNote;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(providers.notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes', style: TextStyle(fontSize: 28)),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              final goRouter = GoRouter.of(context);
              goRouter.push('/login');
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatarWidget(),
            ),
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? (isAddingNote ? _buildAddNoteView() : _buildNotesListView(notes))
          : const others.OthersNotesPage(),

      floatingActionButton: FloatingActionButton(
        onPressed: toggleAddNote,
        child: Icon(isAddingNote ? Icons.cancel : Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Your Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Other\'s Notes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAddNoteView() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            style: const TextStyle(
              fontSize: 26,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: "Title",
              border: InputBorder.none,
            ),
            maxLines: null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: bodyController,
            style: const TextStyle(fontSize: 18, color: Colors.black),
            decoration: const InputDecoration(
              hintText: "Enter your note here...",
              border: InputBorder.none,
            ),
            maxLines: null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final note = Note(
                title: titleController.text,
                body: bodyController.text,
                userId: widget.userId,
                index: 0,
              );
              ref.read(providers.notesProvider.notifier).addNote(note);
              toggleAddNote();
            },
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesListView(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NotesCard(
          note: notes[index],
          index: index,
          onNoteDeleted: (index) => ref
              .read(providers.notesProvider.notifier)
              .deleteNote(index),
          onNoteTitleEdited: (note) {
            ref
                .read(providers.notesProvider.notifier)
                .editNoteTitle(note.index, note.title);
          },
          onNoteBodyEdited: (note) {
            ref
                .read(providers.notesProvider.notifier)
                .editNoteBody(note.index, note.body);
          },
        );
      },
    );
  }
}
