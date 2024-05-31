import 'package:digital_notebook/presentation/widgets/admin_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_notebook/data/dataProvider/notes_provider.dart' as providers;
import 'package:digital_notebook/domain/models/note_model.dart';
import 'package:digital_notebook/presentation/widgets/note_card.dart';

class AdminNotepage extends ConsumerStatefulWidget {
  final String userId;

  const AdminNotepage({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<AdminNotepage> createState() => _AdminNotepageState();
}

class _AdminNotepageState extends ConsumerState<AdminNotepage> {
  bool isAddingNote = false;

  void toggleAddNote() {
    setState(() {
      isAddingNote = !isAddingNote;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(providers.notesProvider);

    return Scaffold(
      body: isAddingNote
          ? _buildAddNoteView()
          : _buildNotesListView(context, notes),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleAddNote,
        child: Icon(isAddingNote ? Icons.cancel : Icons.add),
      ),
    );
  }

  Widget _buildAddNoteView() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

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
            controller: contentController,
            style: const TextStyle(fontSize: 18, color: Colors.black),
            decoration: const InputDecoration(
              hintText: "Enter your note here...",
              border: InputBorder.none,
            ),
            maxLines: null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final note = Note(
                id: null, // Explicitly set id to null
                title: titleController.text.isNotEmpty
                    ? titleController.text
                    : 'Untitled',
                content: contentController.text.isNotEmpty
                    ? contentController.text
                    : 'No content',
                index: 0,
                userId: widget.userId,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              try {
                await ref.read(providers.notesProvider.notifier).addNote(note);
                toggleAddNote();
              } catch (e) {
                print('Failed to save note: $e');
                // Handle error appropriately, e.g., show snackbar or dialog
              }
            },
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesListView(BuildContext context, List<Note> notes) {
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
          onNoteContentEdited: (note) {
            ref
                .read(providers.notesProvider.notifier)
                .editNoteContent(note.index, note.content);
          },
        );
      },
    );
  }
}