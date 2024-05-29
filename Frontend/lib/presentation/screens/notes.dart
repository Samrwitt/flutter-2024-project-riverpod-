import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/note_card.dart';
import '../widgets/avatar.dart';
import 'others.dart' as others; // Use prefix for the import
import 'addnotes.dart';
import '../../providers/notes_provider.dart' as providers; // Use prefix for the import

class Notepage extends StatelessWidget {
  const Notepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: _Notepage(),
    );
  }
}

class _Notepage extends ConsumerWidget {
  const _Notepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(providers.notesProvider); // Use prefixed import
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
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
                    child: CircleAvatarWidget(),
                  ),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.notes), text: 'Notes'),
              Tab(icon: Icon(Icons.people_alt), text: 'Other\'s Notes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NotesCard(
                  note: notes[index],
                  index: index,
                  // Provide required arguments for onNoteDeleted and onNoteEdited
                  onNoteDeleted: (index) => ref.read(providers.notesProvider.notifier).deleteNote(index), // Use prefixed import
                  onNoteEdited: (note) {
                    ref.read(providers.notesProvider.notifier).editNoteTitle(note.index, note.title); // Use prefixed import
                    ref.read(providers.notesProvider.notifier).editNoteBody(note.index, note.body); // Use prefixed import
                  },
                );
              },
            ),
            others.ViewOtherNotesPage(), // Use prefixed import
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNote(
                  onNewNoteCreated: (note) {
                    ref.read(providers.notesProvider.notifier).addNote(note); // Use prefixed import
                  },
                  currentIndex: 0, // Provide the current index
                ),
              ),
            );
          },
          backgroundColor: Colors.blueGrey,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
