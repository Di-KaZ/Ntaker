import 'package:flutter/cupertino.dart';
import 'package:n_taker/interfaces/icategoryprovider.dart';
import 'package:n_taker/model/database.dart';
import 'package:n_taker/model/note.dart';

const String categoryTableName = 'categories';
const String categoryId = 'id';
const String categoryName = 'name';
const String categoryColor = 'color';
const String categoryTotal = 'total';

class Category {
  int? id;
  String name = 'untiled';
  String color = '#ffffff';
  int total = 0;

  Category();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      categoryId: id,
      categoryName: name,
      categoryColor: color
    };
  }

  Category.fromMap(Map<dynamic, dynamic> map) {
    id = map[categoryId];
    name = map[categoryName];
    color = map[categoryColor];
    total = map[categoryTotal];
  }
}

class SqliteCategoryProvider implements ICategoryProvider {
  @override
  Future<Category> insert(Category category) async {
    category.id = await (await SqliteProvider.instance.database)
        .insert(categoryTableName, category.toMap());
    return category;
  }

  @override
  Future<Category?> getById(int? id) async {
    if (id == null) return null;
    List<Map> categories = await (await SqliteProvider.instance.database)
        .query(categoryTableName, where: '$categoryId = ?', whereArgs: [id]);
    if (categories.isEmpty) return Category.fromMap(categories.first);
    return null;
  }

  @override
  Future<List<Category>> getAll() async {
    var categories = await (await SqliteProvider.instance.database).rawQuery('''
            SELECT 
            $categoryId, 
            $categoryName, 
            $categoryColor, 
            (SELECT count(*) FROM $noteTableName WHERE $noteCategory = $categoryTableName.$categoryId) as $categoryTotal 
            FROM $categoryTableName 
          ''');
    if (categories.isNotEmpty) {
      return categories.map((category) => Category.fromMap(category)).toList();
    }
    return [];
  }

  @override
  Future<int> delete(int id) async {
    return await (await SqliteProvider.instance.database)
        .delete(categoryName, where: '$categoryId = ?', whereArgs: [id]);
  }

  @override
  Future<int> update(Category note) async {
    return await (await SqliteProvider.instance.database).update(
        categoryTableName, note.toMap(),
        where: '$categoryId = ?', whereArgs: [note.id]);
  }

  @override
  Future<List<Category>> getPage(int page, [int size = 5]) async {
    List<Map> categories =
        await (await SqliteProvider.instance.database).rawQuery('''
            SELECT 
            $categoryId, 
            $categoryName, 
            $categoryColor, 
            (SELECT count(*) FROM $noteTableName WHERE $noteCategory = $categoryTableName.$categoryId) as $categoryTotal 
            FROM $categoryTableName
            LIMIT $size
            OFFSET ${page * size}
          ''');
    if (categories.isNotEmpty) {
      return categories.map((category) => Category.fromMap(category)).toList();
    }
    return [];
  }

  @override
  Future<int> getCount() async {
    var result = await (await SqliteProvider.instance.database)
        .rawQuery('SELECT count(*) as total FROM $categoryTableName');
    return result.single['total'] as int;
  }
}
