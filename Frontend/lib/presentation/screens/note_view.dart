import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/models/note_model.dart';
//import 'package:digital_notebook/providers/notes_provider.dart';

final currentlyEditedNoteProvider = StateProvider<Note>((ref) => throw UnimplementedError());

class NoteView extends ConsumerStatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends ConsumerState<NoteView> {
  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(currentlyEditedNoteProvider);

    titleController = TextEditingController(text: note.title);
    bodyController = TextEditingController(text: note.body);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: titleController,
          style: const TextStyle(fontSize: 30.0, color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Title',
            hintStyle: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: const Text(
                      "Delete Note ?",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    content: Text("Note '${titleController.text}' will be deleted!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(currentlyEditedNoteProvider.notifier).state = Note(  title: titleController.text,
                          body: bodyController.text,
                          index: note.index,); // Reset the currently edited note
                          Navigator.of(context).pop();
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ref.read(currentlyEditedNoteProvider.notifier).state = note.copyWith(
                title: titleController.text,
                body: bodyController.text,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            TextField(
              controller: bodyController,
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
}