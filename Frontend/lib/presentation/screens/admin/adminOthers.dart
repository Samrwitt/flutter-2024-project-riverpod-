import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import '../../../models/note_model.dart';
import '../../../providers/notes_provider.dart';

class AdminOthersPage extends ConsumerWidget {
  const AdminOthersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);

    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.grey[700],
        ),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return OthersNotesCard(
              title: note.title,
              content: note.body,
              onTap: () {
                _showNoteDetails(context, note.title);
              },
            );
          }, 
        ),
      ),
    );
  }

  void _showNoteDetails(BuildContext context, String noteTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OthersNoteDetailsDialog(noteTitle: noteTitle);
      },
    );
  }
}

class OthersNoteDetailsDialog extends StatelessWidget {
  final String noteTitle;

  const OthersNoteDetailsDialog({required this.noteTitle, Key? key}) : super(key: key);

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
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
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

class OthersNotesCard extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onTap;

  const OthersNotesCard({
    Key? key,
    required this.title,
    required this.content,
    required this.onTap,
  }) : super(key: key);

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
