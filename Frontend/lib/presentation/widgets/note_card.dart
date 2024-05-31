import 'package:flutter/material.dart';
import 'package:digital_notebook/domain/models/note_model.dart';

class NotesCard extends StatefulWidget {
  final Note note;
  final int index;
  final Function(int) onNoteDeleted;
  final Function(Note) onNoteTitleEdited;
  final Function(Note) onNoteContentEdited;

  const NotesCard({
    Key? key,
    required this.note,
    required this.index,
    required this.onNoteDeleted,
    required this.onNoteTitleEdited,
    required this.onNoteContentEdited,
  }) : super(key: key);

  @override
  _NotesCardState createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _updateNote() {
    if (titleController.text != widget.note.title) {
      widget.onNoteTitleEdited(widget.note.copyWith(
        title: titleController.text,
        updatedAt: DateTime.now(),
      ));
    }
    if (contentController.text != widget.note.content) {
      widget.onNoteContentEdited(widget.note.copyWith(
        content: contentController.text,
        updatedAt: DateTime.now(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(border: InputBorder.none),
              onSubmitted: (value) {
                _updateNote();
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(border: InputBorder.none),
              onSubmitted: (value) {
                _updateNote();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _updateNote,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    widget.onNoteDeleted(widget.index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}