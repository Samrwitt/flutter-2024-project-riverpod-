import 'package:flutter/material.dart';
import 'package:digital_notebook/models/note_model.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key, required this.onNewNoteCreated, required this.currentIndex})
      : super(key: key);

  final Function(Note) onNewNoteCreated;
  final int currentIndex;

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
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
                  fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
              maxLines: null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _bodyController,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter your note here...",
              ),
              maxLines: null,
            ),
            ElevatedButton(
              onPressed: () {
                final note = Note(
                  title: _titleController.text,
                  body: _bodyController.text,
                  index: widget.currentIndex,
                );
                widget.onNewNoteCreated(note);
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
