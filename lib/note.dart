import 'database.dart';

const String noteTableName = 'notes';
const String noteId = 'id';
const String noteName = 'name';
const String noteData = 'data';
const String noteCreation = 'creation';
const String noteModified = 'modified';

class Note {
  int? id;
  String? name;
  String? data;
  String creation = 'now';
  // final String modified;

  Note();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      noteId: id,
      noteName: name,
      noteData: data,
      noteCreation: creation,
      // colModified: modified
    };
  }

  Note.fromMap(Map<dynamic, dynamic> map) {
    id = map[noteId];
    name = map[noteName];
    data = map[noteData];
  }
}

class NoteProvider {
  Future<Note> insert(Note note) async {
    note.id = await (await DataBase.instance.database)
        .insert(noteTableName, note.toMap());
    return note;
  }

  Future<Note?> getById(int id) async {
    List<Map> notes = await (await DataBase.instance.database)
        .query(noteTableName, where: '$noteId = ?', whereArgs: [id]);
    if (notes.isNotEmpty) return Note.fromMap(notes.first);
    return null;
  }

  Future<List<Note>> getAll() async {
    List<Map> notes =
        await (await DataBase.instance.database).query(noteTableName);
    if (notes.isNotEmpty) {
      return notes.map((note) => Note.fromMap(note)).toList();
    }
    return [];
  }

  Future<int> delete(int id) async {
    return await (await DataBase.instance.database)
        .delete(noteTableName, where: '$noteId = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async {
    return await (await DataBase.instance.database).update(
        noteTableName, note.toMap(),
        where: '$noteId = ?', whereArgs: [note.id]);
  }
}
