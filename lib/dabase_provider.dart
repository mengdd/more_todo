import 'package:more_todo/data/categories_dao.dart';
import 'package:more_todo/data/todo_database.dart';
import 'package:more_todo/data/todos_dao.dart';

class DatabaseProvider {
  TodosDao _todosDao;
  CategoriesDao _categoriesDao;

  TodosDao get todosDao => _todosDao;

  CategoriesDao get categoriesDao => _categoriesDao;

  DatabaseProvider() {
    TodoDatabase database = TodoDatabase();
    _todosDao = TodosDao(database);
    _categoriesDao = CategoriesDao(database);
  }
}
