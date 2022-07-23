import 'package:n_taker/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'note.dart';

class DataBase {
  static const String databaseName = 'n_taker.db';

  DataBase._constructor();
  static final DataBase instance = DataBase._constructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    return await openDatabase(
        (await getApplicationDocumentsDirectory()).path + databaseName,
        version: 1,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $noteTableName(
      $noteId INTEGER PRIMARY KEY,
      $noteName TEXT,
      $noteData BLOB,
      $noteCreation TEXT,
      $noteModified TEXT
    )
    ''');
  }
}
