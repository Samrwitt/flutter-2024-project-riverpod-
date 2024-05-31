import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_notebook/domain/models/note_model.dart';

// Ensure your Note model and provider paths are correct
final currentlyEditedNoteProvider = StateProvider<Note>((ref) => throw UnimplementedError());

class NoteView extends ConsumerStatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends ConsumerState<NoteView> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current note values
    try {
      final note = ref.read(currentlyEditedNoteProvider);
      titleController = TextEditingController(text: note.title);
      contentController = TextEditingController(text: note.content);
    } catch (e) {
      print('Error initializing note controllers: $e');
      titleController = TextEditingController();
      contentController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(currentlyEditedNoteProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: titleController,
          style: const TextStyle(fontSize: 30.0, color: Colors.white),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Title',
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveNote(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Note",
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Delete Note?", style: TextStyle(color: Colors.white)),
          content: Text("Note '${titleController.text}' will be deleted!"),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Add your delete logic here
                // For example, you might want to call a method to delete the note from the backend or state
                context.pop(); // Close the dialog
                context.pop(); // Navigate back from NoteView
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _saveNote() {
    final note = ref.read(currentlyEditedNoteProvider);
    if (note != null) {
      ref.read(currentlyEditedNoteProvider.notifier).update(
            (state) => state.copyWith(
              title: titleController.text,
              content: contentController.text,
            ),
          );
      // Call a method to save the note to the backend or state
    }
    context.pop(); // Close the NoteView after saving
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}