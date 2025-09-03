import 'package:hive/hive.dart';
import '../models/note.dart';

class NoteService {
  static final Box<Note> _noteBox = Hive.box<Note>('notes');

  static List<Note> getNotes() {
    return _noteBox.values.toList();
  }

  static Future<void> addNote(Note note) async {
    await _noteBox.add(note);
  }

  static Future<void> updateNote(Note note) async {
    await note.save();
  }

  static Future<void> deleteNote(Note note) async {
    await note.delete();
  }
}
