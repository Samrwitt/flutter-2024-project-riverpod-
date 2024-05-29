import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Background color similar to Samsung Notes
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Colors.blue, // Samsung Notes uses blue for the app bar
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return NotesCard(
            title: 'Note ${index + 1}',
            content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', // Sample note content
            onTap: () {
              _showNoteDetails(context, 'Note ${index + 1}');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle floating action button press
        },
        backgroundColor: Colors.blue, // Match the app bar color
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNoteDetails(BuildContext context, String noteTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDetailsDialog(noteTitle: noteTitle);
      },
    );
  }
}

class NotesCard extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onTap;

  const NotesCard({
    super.key,
    required this.title,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2, // Add some elevation for a card-like appearance
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Add margin between cards
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16, // Increase font size for better readability
            ),
          ),
          subtitle: Text(
            content,
            maxLines: 2, // Show only 2 lines of note content
            overflow: TextOverflow.ellipsis, // Add ellipsis if content exceeds 2 lines
          ),
          trailing: const Icon(Icons.arrow_forward_ios), // Add a trailing icon for a Samsung Notes-like appearance
        ),
      ),
    );
  }
}

class NoteDetailsDialog extends StatelessWidget {
  final String noteTitle;

  const NoteDetailsDialog({required this.noteTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            noteTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Note content goes here...', // Replace with actual note content
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
