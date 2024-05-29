import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Note {
  final String title;
  final String content;

  Note({required this.title, required this.content});
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier([
    Note(
      title: 'Note 1',
      content: 'This is the content of note 1.',
    ),
    Note(
      title: 'Note 2',
      content: 'This is the content of note 2.',
    ),
    Note(
      title: 'Note 3',
      content: 'This is the content of note 3.',
    ),
  ]);
});

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier(List<Note> notes) : super(notes);
}

class ViewNotesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);

    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.grey[400],
        ),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return OthersNotesCard(
              title: note.title,
              content: note.content,
              onTap: () {
                _showNoteDetails(context, note.title);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                // Navigate to NotesPage
                Navigator.pop(context);
              },
              icon: const Icon(Icons.notes),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewOtherNotesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.grey[700],
        ),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return OthersNotesCard(
              title: 'Note ${index + 1}',
              content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              onTap: () {
                _showNoteDetails(context, 'Note ${index + 1}');
              },
            );
          },
        ),
      ),
    );
  }
}

class OthersNoteDetailsDialog extends StatelessWidget {
  final String noteTitle;

  const OthersNoteDetailsDialog({required this.noteTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[700],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            noteTitle,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Cillum tempor aute do esse exercitation nulla tempor. Non laborum enim tempor amet quis minim fugiat. Nulla aliqua consequat duis qui aliquip Lorem.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Back'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showNoteDetails(BuildContext context, String noteTitle) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return OthersNoteDetailsDialog(noteTitle: noteTitle);
    },
  );
}

class OthersNotesCard extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onTap;

  const OthersNotesCard({
    super.key,
    required this.title,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(content),
        onTap: onTap,
      ),
    );
  }
}

void main() {
  runApp(ProviderScope(
    child: MaterialApp(
      home: ViewNotesPage(),
    ),
  ));
}