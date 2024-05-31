// lib/data/repositories/notes_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:digital_notebook/domain/models/note_model.dart';

class NotesRepository {
  final http.Client client;

  NotesRepository(this.client);

  Future<List<Note>> fetchNotes(String userId, String token) async {
    final response = await client.get(
      Uri.parse('http://localhost:3000/notes'),
      headers: {
        'Authorization': 'Bearer $token',
        'user-id': userId,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body) as List;
      return responseBody.map((note) => Note.fromJson(note)).toList();
    } else {
      throw Exception('Failed to fetch notes. Status code: ${response.statusCode}');
    }
  }

  Future<Note> addNote(Note note, String token, String userId) async {
    final response = await client.post(
      Uri.parse('http://localhost:3000/notes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'user-id': userId,
      },
      body: jsonEncode(note.copyWith(id: null).toJson()),
    );

    if (response.statusCode == 201) {
      return Note.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add note. Status code: ${response.statusCode}');
    }
  }

  Future<Note> editNoteTitle(String noteId, String title, String token, String userId) async {
    final response = await client.patch(
      Uri.parse('http://localhost:3000/notes/$noteId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'user-id': userId,
      },
      body: jsonEncode({'title': title}),
    );

    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to edit note title. Status code: ${response.statusCode}');
    }
  }

  Future<Note> editNoteContent(String noteId, String content, String token, String userId) async {
    final response = await client.patch(
      Uri.parse('http://localhost:3000/notes/$noteId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'user-id': userId,
      },
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to edit note content. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteNote(String noteId, String token, String userId) async {
    final response = await client.delete(
      Uri.parse('http://localhost:3000/notes/$noteId'),
      headers: {
        'Authorization': 'Bearer $token',
        'user-id': userId,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete note. Status code: ${response.statusCode}');
    }
  }
}
