
import 'package:digital_notebook/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/models/note_model.dart';
import 'auth_provider.dart'; // Ensure the correct path

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier(ref);
});

class NotesNotifier extends StateNotifier<List<Note>> {
  final Ref _ref;

  NotesNotifier(this._ref) : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final userId = await _ref.read(authProviderProvider).userId;
      if (userId != null) {
        await _fetchNotes(userId);
      } else {
        print('User ID is null');
      }
    } catch (e) {
      print('Failed to initialize notes: $e');
    }
  }

  Future<void> _fetchNotes(String userId) async {
    final client = _ref.read(httpProvider);
    final token = await _ref.read(authProviderProvider).authToken;

    // Debugging: Print the user ID
    print('Fetching notes for user with ID: $userId');

    try {
      final response = await client.get(
        Uri.parse('http://localhost:3000/notes'), // No need to include user ID in the URL
        headers: {
          'Authorization': 'Bearer $token', // Include token in headers
          'user-id': userId, // Include user ID in headers
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as List;

        // Debugging: Print the parsed response
        print('Parsed response: $responseBody');

        final notes = responseBody.map((note) => Note.fromJson(note)).toList();

        // Additional debugging: Print the list of notes
        notes.forEach((note) => print('Fetched Note: ${note.toJson()}'));

        state = notes;
      } else {
        print('Failed to fetch notes. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch notes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch notes: $e');
      throw Exception('Failed to fetch notes: $e');
    }
  }

  Future<void> addNote(Note note) async {
    final client = _ref.read(httpProvider);
    final token = await _ref.read(authProviderProvider).authToken;
    final userId = await _ref.read(authProviderProvider).userId;
    if (token == null) {
      print('Auth token is null');
      return;
    }

    // Make sure the id is null for new notes
    final noteToAdd = note.copyWith(id: null);
    final body = jsonEncode(noteToAdd.toJson());

    // Debugging: Print the values to ensure they are not null
    print('Token: $token');
    print('Note to add: $body');

    try {
      final response = await client.post(
        Uri.parse('http://localhost:3000/notes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'user-id': '$userId',
        },
        body: body,
      );
      print("res: ${response.statusCode}");
      print('res: ${response.body}');

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);

        // Ensure the response body contains all required fields
        if (responseBody['_id'] == null ||
            responseBody['title'] == null ||
            responseBody['content'] == null ||
            responseBody['userId'] == null ||
            responseBody['index'] == null ||
            responseBody['createdAt'] == null ||
            responseBody['updatedAt'] == null) {
          print('Invalid response format: $responseBody');
          throw Exception('Invalid response format');
        }

        final createdNote = Note.fromJson(responseBody);

        // Additional debugging: Print the created note
        print('Created Note: ${createdNote.toJson()}');


state = [...state, createdNote];
      } else {
        print('Failed to add note. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add note. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to add note: $e');
      throw Exception('Failed to add note: $e');
    }
  }

  Future<void> editNoteTitle(int index, String title) async {
    final client = _ref.read(httpProvider);
    final userId = await _ref.read(authProviderProvider).userId;
    final token = await _ref.read(authProviderProvider).authToken;
    final updatedNote = state[index].copyWith(title: title);

    // Debugging: Print the note ID and new title
    print('Editing Note ID: ${updatedNote.id}');
    print('New Title: $title');

    try {
      final response = await client.patch(
        Uri.parse('http://localhost:3000/notes/${updatedNote.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'user-id': '$userId',
        },
        body: jsonEncode({'title': updatedNote.title}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final updatedNoteFromServer = Note.fromJson(jsonDecode(response.body));
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == index) updatedNoteFromServer else state[i],
        ];
      } else {
        print('Failed to edit note title. Status code: ${response.statusCode}');
        throw Exception('Failed to edit note title. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to edit note title: $e');
      throw Exception('Failed to edit note title: $e');
    }
  }

  Future<void> editNoteContent(int index, String content) async {
    final client = _ref.read(httpProvider);
    final userId = await _ref.read(authProviderProvider).userId;
    final token = await _ref.read(authProviderProvider).authToken;
    final updatedNote = state[index].copyWith(content: content);

    // Debugging: Print the note ID and new content
    print('Editing Note ID: ${updatedNote.id}');
    print('New Content: $content');

    try {
      final response = await client.patch(
        Uri.parse('http://localhost:3000/notes/${updatedNote.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'user-id': '$userId',
        },
        body: jsonEncode({'content': updatedNote.content}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final updatedNoteFromServer = Note.fromJson(jsonDecode(response.body));
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == index) updatedNoteFromServer else state[i],
        ];
      } else {
        print('Failed to edit note content. Status code: ${response.statusCode}');
        throw Exception('Failed to edit note content. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to edit note content: $e');
      throw Exception('Failed to edit note content: $e');
    }
  }

  Future<void> deleteNote(int index) async {
    final client = _ref.read(httpProvider);
    final userId = await _ref.read(authProviderProvider).userId;
    final token = await _ref.read(authProviderProvider).authToken;
    final noteId = state[index].id;

    // Debugging: Print the note ID to be deleted
    print('Deleting Note ID: $noteId');

    try {
      final response = await client.delete(
        Uri.parse('http://localhost:3000/notes/$noteId'),
        headers: {
          'Authorization': 'Bearer $token',
          'user-id': '$userId',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');


if (response.statusCode == 200) {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i != index) state[i],
        ];
      } else {
        print('Failed to delete note. Status code: ${response.statusCode}');
        throw Exception('Failed to delete note. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to delete note: $e');
      throw Exception('Failed to delete note: $e');
    }
  }
}