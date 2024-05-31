import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/models/note_model.dart';
import 'package:digital_notebook/providers/notes_provider.dart';

class AdminNotepage extends ConsumerStatefulWidget {
  const AdminNotepage({Key? key, required this.currentIndex}) : super(key: key);

  final int currentIndex;

  @override
  ConsumerState<AdminNotepage> createState() => AdminNotepageState();
}

class AdminNotepageState extends ConsumerState<AdminNotepage> {
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

  void _showEditNoteDialog(BuildContext context, int index, Note note) {
    final editTitleController = TextEditingController(text: note.title);
    final editBodyController = TextEditingController(text: note.body);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: editTitleController,
                style: const TextStyle(fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                ),
                maxLines: null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: editBodyController,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your note here...",
                ),
                maxLines: null,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                ref.read(notesProvider.notifier).editNoteTitle(index, editTitleController.text);
                ref.read(notesProvider.notifier).editNoteBody(index, editBodyController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);
    

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     isAddingNote ? 'Add Note' : 'Notes',
      //     style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      //   ),
      //   actions: isAddingNote
      //       ? [
      //           IconButton(
      //             icon: const Icon(Icons.cancel),
      //             onPressed: toggleAddNote,
      //           ),
      //         ]
      //       : null,
      // ),
      body: isAddingNote
          ? Padding(
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
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.body),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditNoteDialog(context, index, note);
                    },
                  ),
                  onTap: () {
                    // Handle note tap if needed
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
