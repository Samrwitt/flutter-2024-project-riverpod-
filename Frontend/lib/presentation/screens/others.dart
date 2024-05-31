import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_notebook/providers/ui_provider.dart';
import 'package:digital_notebook/providers/notes_provider.dart';
import 'package:digital_notebook/presentation/widgets/email.dart';

final emailFieldProvider =
    ChangeNotifierProvider((ref) => EmailFieldProvider());
final uiProviderProvider = ChangeNotifierProvider((ref) => UIProvider());

class OthersNotesPage extends ConsumerWidget {
  const OthersNotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('View Notes'),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => context.pop(), // Using GoRouter to navigate back
      //   ),
      // ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return OthersNotesCard(
            title: note.title,
            content: note.body,
            onTap: () => _showNoteDetails(context, note.title, note.body),
          );
        },
      ),
    );
  }

  void _showNoteDetails(
      BuildContext context, String noteTitle, String noteBody) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OthersNoteDetailsDialog(
            noteTitle: noteTitle, noteBody: noteBody);
      },
    );
  }
}

class OthersNoteDetailsDialog extends StatelessWidget {
  final String noteTitle;
  final String noteBody;

  const OthersNoteDetailsDialog({
    required this.noteTitle,
    required this.noteBody,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[700],
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              child: Text(
                noteBody,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(), // Use GoRouter to close the dialog
            child: const Text('Back'),
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
