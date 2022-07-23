import 'package:n_taker/note.dart';

abstract class INoteProvider {
  /// Inserting a note into the database.
  Future<Note> insert(Note note);

  /// Returning a Future of a Note that can be null.
  Future<Note?> getById(int id);

  /// Returning a Future of a List of Notes.
  Future<List<Note>> getAll();

  /// Deleting a note from the database.
  Future<int> delete(int id);

  /// Updating the note.
  Future<int> update(Note note);
}
