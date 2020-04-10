import 'package:moor/moor.dart';
import 'package:more_todo/data/categories.dart';
import 'package:more_todo/data/todo_database.dart';

part 'categories_dao.g.dart';

// the _TodosDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<TodoDatabase>
    with _$CategoriesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  CategoriesDao(TodoDatabase db) : super(db);

  Future<List<Category>> getAllCategories() => select(categories).get();

  Stream<List<Category>> watchAllCategories() => select(categories).watch();

  Future insertCategory(CategoriesCompanion categoryCompanion) =>
      into(categories).insert(categoryCompanion);

  Future updateCategory(Category category) =>
      update(categories).replace(category);

  Future deleteCategory(Category category) =>
      delete(categories).delete(category);
}
