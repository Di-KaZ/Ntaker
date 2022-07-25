import 'package:n_taker/model/category.dart';

abstract class ICategoryProvider {
  /// Inserting a note into the database.
  Future<Category> insert(Category category);

  /// Returning a Future of a Category that can be null.
  Future<Category?> getById(int? id);

  /// Returning a Future of a List of Categorys.
  Future<List<Category>> getAll();

  Future<int> getCount();

  Future<List<Category>> getPage(int page, [int size = 5]);

  /// Deleting a Category from the database.
  Future<int> delete(int id);

  /// Updating the Category.
  Future<int> update(Category category);
}
