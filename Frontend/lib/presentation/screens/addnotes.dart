import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package
import 'package:digital_notebook/domain/models/note_model.dart';
import 'package:go_router/go_router.dart';

class AddNote extends StatefulWidget {
  const AddNote({
    Key? key,
    required this.onNewNoteCreated,
    required this.currentIndex,
    required this.userId,
  }) : super(key: key);

  final Function(Note) onNewNoteCreated;
  final int currentIndex;
  final String userId;

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Note',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w300),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              style: const TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
              maxLines: null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _contentController,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter your note here...",
              ),
              maxLines: null,
            ),
            ElevatedButton(
              onPressed: () {
                 // Create a new instance of Uuid
                final note = Note(
                  title: _titleController.text.isNotEmpty ? _titleController.text :'Untitled',
                  content: _contentController.text.isNotEmpty ? _contentController.text :'No content',
                  index: widget.currentIndex,
                  userId: widget.userId,
                  createdAt:DateTime.now(),
                  updatedAt:DateTime.now(),
                );

                // Debugging: Print the note values to ensure they are not null
                print('Note to add: ${note.toJson()}');

                widget.onNewNoteCreated(note);
                context.pop(); // Using GoRouter to navigate back
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
