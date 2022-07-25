import 'package:n_taker/interfaces/inoteprovider.dart';
import 'package:n_taker/model/category.dart';

import 'database.dart';

const String noteTableName = 'notes';
const String noteId = 'id';
const String noteName = 'name';
const String noteData = 'data';
const String notePreview = 'preview';
const String noteCreation = 'creation';
const String noteModified = 'modified';
const String noteFavorite = 'favorite';
const String noteCategory = 'category';

class Note {
  int? id;
  String name = 'untiled';
  String? data;
  String creation = DateTime.now().toString();
  String modified = DateTime.now().toString();
  String preview = '';
  bool favorite = false;
  Category? category;

  Note();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      noteId: id,
      noteName: name,
      noteData: data,
      noteCreation: creation,
      noteModified: modified,
      notePreview: preview,
      noteFavorite: favorite ? 1 : 0,
      noteCategory: category != null ? category!.id : null
    };
  }

  Note.fromMap(Map<dynamic, dynamic> map) {
    id = map[noteId];
    name = map[noteName];
    data = map[noteData];
    creation = map[noteCreation];
    modified = map[noteModified];
    preview = map[notePreview];
    favorite = map[noteFavorite] == 1;
    if (map[noteCategory] != null) {
      var cat = Category();
      cat.color = map[categoryColor];
      cat.name = map['categoryName'];
      cat.id = map[noteCategory];
      category = cat;
    }
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
  Future<Note?> getById(int? id) async {
    if (id == null) return null;
    List<Map> notes =
        await (await SqliteProvider.instance.database).rawQuery('''
      SELECT $noteTableName.*, cat.$categoryName as categoryName, cat.$categoryColor  
      FROM $noteTableName
      LEFT JOIN $categoryTableName cat on cat.$categoryId = $noteCategory
      WHERE $noteTableName.$noteId = $id
      ''');
    return Note.fromMap(notes.single);
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
  Future<List<Note>> getPage(int page,
      [int size = 5, bool? favorite, String? category]) async {
    String filter = '';
    List<Object> args = [];

    if (favorite != null) {
      filter += 'WHERE $noteFavorite = $favorite';
      args.add(favorite ? 1 : 0);
    }

    // Todo category

    List<Map> notes =
        await (await SqliteProvider.instance.database).rawQuery('''
      SELECT $noteTableName.*, cat.$categoryName as categoryName, cat.$categoryColor  
      FROM $noteTableName
      LEFT JOIN $categoryTableName cat on cat.$categoryId = $noteCategory
      $filter 
      ORDER BY $noteId ASC;
      LIMIT $size 
      OFFSET ${page * size}
      ''');
    if (notes.isNotEmpty) {
      return notes.map((note) => Note.fromMap(note)).toList();
    }
    return [];
  }
}
