import 'package:n_taker/model/category.dart';
import 'package:n_taker/model/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'note.dart';

class SqliteProvider {
  static const String databaseName = 'n_taker.db';

  SqliteProvider._constructor();
  static final SqliteProvider instance = SqliteProvider._constructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    return await openDatabase(
        '${(await getApplicationDocumentsDirectory()).path}/$databaseName',
        version: 1,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    var queries = [
      '''
    CREATE TABLE $categoryTableName(
       $categoryId INTEGER PRIMARY KEY,
       $categoryName TEXT,
       $categoryColor TEXT
    );
    ''',
      '''
    CREATE TABLE $noteTableName(
      $noteId INTEGER PRIMARY KEY,
      $noteName TEXT,
      $noteData BLOB,
      $notePreview TEXT,
      $noteCreation TEXT,
      $noteModified TEXT,
      $noteFavorite BOOL,
      $noteCategory INTEGER,
      FOREIGN KEY($noteCategory) REFERENCES $categoryTableName($categoryId)
    );
    ''',
      '''INSERT INTO $categoryTableName values (NULL, 'Todo', '#ff0000');''',
      '''INSERT INTO $categoryTableName values (NULL, 'Design', '#00ff00');''',
      '''INSERT INTO $categoryTableName values (NULL, 'Freelance', '#0000ff');''',
      '''INSERT INTO $categoryTableName values (NULL, 'Scientific', '#ff00ff');''',
      '''CREATE INDEX noteIndex ON $noteTableName(id);''',
      '''CREATE INDEX categoryIndex ON $categoryTableName(id);'''
    ];

    for (var query in queries) {
      await db.execute(query);
    }
  }
}
