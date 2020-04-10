import 'package:more_todo/data/todo_database.dart';
import 'package:more_todo/data/todos_dao.dart';

class DatabaseProvider {
  TodosDao _todosDao;

  TodosDao get todosDao => _todosDao;

  DatabaseProvider() {
    TodoDatabase database = TodoDatabase();
    _todosDao = TodosDao(database);
  }
}
