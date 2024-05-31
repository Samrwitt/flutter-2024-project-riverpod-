import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_notebook/data/models/note_model.dart';
import 'package:digital_notebook/application/providers/notes_provider.dart' as providers;
import "package:digital_notebook/presentation/widgets/note_card.dart";

class AdminNotepage extends ConsumerStatefulWidget {
  const AdminNotepage({
    Key? key,
    required this.currentIndex,
    required this.userId,
  }) : super(key: key);

  final int currentIndex;
  final String userId;

  @override
  ConsumerState<AdminNotepage> createState() => _AdminNotepageState();
}

class _AdminNotepageState extends ConsumerState<AdminNotepage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool isAddingNote = false;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  void toggleAddNote() {
    setState(() {
      isAddingNote = !isAddingNote;
      titleController.clear();
      bodyController.clear();
    });
  }

  void _showEditNoteDialog(int index, Note note) {
    final editTitleController = TextEditingController(text: note.title);
    final editBodyController = TextEditingController(text: note.body);

    context.push('/editNote', extra: {
      'index': index,
      'editTitleController': editTitleController,
      'editBodyController': editBodyController,
      'note': note,
      'onSave': () {
        ref
            .read(providers.notesProvider.notifier)
            .editNoteTitle(index, editTitleController.text);
        ref
            .read(providers.notesProvider.notifier)
            .editNoteBody(index, editBodyController.text);
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(providers.notesProvider);

    return Scaffold(
      body: isAddingNote
          ? Padding(
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
                        index: widget.currentIndex,
                        userId: widget.userId,
                      );
                      ref.read(providers.notesProvider.notifier).addNote(note);
                      toggleAddNote();
                    },
                    child: const Text('Save Note'),
                  ),
                ],
              ),
            )
          : ListView.builder(
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
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: toggleAddNote,
        child: Icon(isAddingNote ? Icons.cancel : Icons.add),
      ),
    );
  }
}
