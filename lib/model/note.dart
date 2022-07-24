import 'package:n_taker/interfaces/inoteprovider.dart';

import 'database.dart';

const String noteTableName = 'notes';
const String noteId = 'id';
const String noteName = 'name';
const String noteData = 'data';
const String notePreview = 'preview';
const String noteCreation = 'creation';
const String noteModified = 'modified';

class Note {
  int? id;
  String name = 'untiled';
  String? data;
  String creation = DateTime.now().toString();
  String modified = DateTime.now().toString();
  String preview = '';

  Note();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      noteId: id,
      noteName: name,
      noteData: data,
      noteCreation: creation,
      noteModified: modified,
      notePreview: preview
    };
  }

  Note.fromMap(Map<dynamic, dynamic> map) {
    id = map[noteId];
    name = map[noteName];
    data = map[noteData];
    creation = map[noteCreation];
    modified = map[noteModified];
    preview = map[notePreview];
  }
}

class SqliteNoteProvider implements INoteProvider {
  @override
  Future<Note> insert(Note note) async {
    note.modified = DateTime.now().toString();
    note.id = await (await SqliteProvider.instance.database)
        .insert(noteTableName, note.toMap());
    return note;
  }

  @override
  Future<Note?> getById(int id) async {
    List<Map> notes = await (await SqliteProvider.instance.database)
        .query(noteTableName, where: '$noteId = ?', whereArgs: [id]);
    if (notes.isNotEmpty) return Note.fromMap(notes.first);
    return null;
  }

  @override
  Future<List<Note>> getAll() async {
    List<Map> notes =
        await (await SqliteProvider.instance.database).query(noteTableName);
    if (notes.isNotEmpty) {
      return notes.map((note) => Note.fromMap(note)).toList();
    }
    return [];
  }

  @override
  Future<int> delete(int id) async {
    return await (await SqliteProvider.instance.database)
        .delete(noteTableName, where: '$noteId = ?', whereArgs: [id]);
  }

  @override
  Future<int> update(Note note) async {
    return await (await SqliteProvider.instance.database).update(
        noteTableName, note.toMap(),
        where: '$noteId = ?', whereArgs: [note.id]);
  }

  @override
  Future<List<Note>> getPage(int page, [int size = 5]) async {
    List<Map> notes = await (await SqliteProvider.instance.database)
        .query(noteTableName, limit: size, offset: page * size);
    if (notes.isNotEmpty) {
      return notes.map((note) => Note.fromMap(note)).toList();
    }
    return [];
  }
}