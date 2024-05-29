import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/models/note_model.dart';

// Provider for the list of notes
final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) => NotesNotifier());

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  void addNote(Note note) {
    state = [...state, note];
  }

  void editNoteTitle(int index, String title) {
    state[index] = state[index].copyWith(title: title);
    state = [...state];
  }

  void editNoteBody(int index, String body) {
    state[index] = state[index].copyWith(body: body);
    state = [...state];
  }

  void deleteNote(int index) {
    state.removeAt(index);
    state = [...state];
  }
}