import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/models/note_model.dart';
import 'package:digital_notebook/providers/notes_provider.dart';

class AdminNotepage extends ConsumerStatefulWidget {
  const AdminNotepage({Key? key, required this.currentIndex, required Null Function(dynamic note) onNewNoteCreated}) : super(key: key);

  final int currentIndex;

  @override
  ConsumerState<AdminNotepage> createState() => AdminNotepageState();
}

class AdminNotepageState extends ConsumerState<AdminNotepage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Note',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              style: const TextStyle(fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
              maxLines: null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: bodyController,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter your note here...",
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
                );
                ref.read(notesProvider.notifier).addNote(note);
                Navigator.pop(context);
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
