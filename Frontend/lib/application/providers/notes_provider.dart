import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/data/models/note_model.dart';

// Provider for the list of notes
final notesProvider =
    StateNotifierProvider<NotesNotifier, List<Note>>((ref) => NotesNotifier());

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  void addNote(Note note) {
    state = [...state, note];
  }

  void editNoteTitle(int index, String title) {
    final updatedNote = state[index].copyWith(title: title);
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updatedNote else state[i],
    ];
  }

  void editNoteBody(int index, String body) {
    final updatedNote = state[index].copyWith(body: body);
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updatedNote else state[i],
    ];
  }

  void deleteNote(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }
}
