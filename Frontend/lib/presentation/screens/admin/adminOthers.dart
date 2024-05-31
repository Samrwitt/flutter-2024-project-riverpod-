import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/notes_provider.dart';

class AdminOthersPage extends ConsumerWidget {
  const AdminOthersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Other\'s Notes'),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => context.pop(), // Using GoRouter to navigate back
      //   ),
      // ),
      body: Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Color.fromARGB(255, 251, 251, 251),
        ),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return OthersNotesCard(
              title: note.title,
              content: note.body,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => OthersNoteDetailsDialog(
                    noteTitle: note.title,
                    noteBody: note.body,
                  ),
                );
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
  final String noteBody;

  const OthersNoteDetailsDialog({
    required this.noteTitle,
    required this.noteBody,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
          SingleChildScrollView(
            child: Text(
              noteBody,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(), // Using GoRouter to navigate back
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
