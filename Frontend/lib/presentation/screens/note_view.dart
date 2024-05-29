import 'package:digital_notebook/models/note_model.dart';
import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  final Note note;
  final int index;
  final Function(Note) onNoteEdited;
  final Function(int) onNoteDeleted;

  const NoteView(
    // ignore: non_constant_identifier_names
    {super.key, required this.note, required this.index, required this.onNoteEdited, required this.onNoteDeleted, required Function(int p1, String p2, String p3) Function});

  @override
  NoteViewState createState() => NoteViewState();
}

class NoteViewState extends State<NoteView> {
  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    bodyController = TextEditingController(text: widget.note.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
        controller: titleController,
        style: const TextStyle(fontSize: 30.0, color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white.withAlpha(120)),
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
                    title: const Text("Delete Note ?",
                    style: TextStyle(
                      color:Colors.white,
                    ),),
                    content: Text("Note '${titleController.text}' will be deleted!"),
                    actions:[
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: (){
                          widget.onNoteDeleted(widget.index);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Delete"),
                      ),
                    ]
                  );
                }
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              widget.note.title = titleController.text; widget.note.body = bodyController.text; widget.onNoteEdited(widget.note);
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
            // TextField(
            //   controller: titleController,
            //   style: const TextStyle(
            //     fontSize: 30, color:
            //     Colors.black, fontWeight:
            //     FontWeight.bold,
            //     ),
            //     decoration: const InputDecoration(
            //       hintText: "Title",
            //       border: InputBorder.none,
            //     ),
            // ),
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