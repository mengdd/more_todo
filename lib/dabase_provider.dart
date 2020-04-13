import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:more_todo/data/categories_dao.dart';
import 'package:more_todo/data/todo_database.dart';
import 'package:more_todo/data/todo_with_category.dart';
import 'package:more_todo/data/todos_dao.dart';

class DatabaseProvider extends ChangeNotifier {
  TodosDao _todosDao;
  CategoriesDao _categoriesDao;
  Category _selectedCategory;
  bool _hideCompleted = false;

  bool get hideCompleted => _hideCompleted;

  set hideCompleted(bool value) {
    _hideCompleted = value;
    notifyListeners();
  }

  Category get selectedCategory => _selectedCategory;

  TodosDao get todosDao => _todosDao;

  CategoriesDao get categoriesDao => _categoriesDao;

  DatabaseProvider() {
    TodoDatabase database = TodoDatabase();
    _todosDao = TodosDao(database);
    _categoriesDao = CategoriesDao(database);
  }

  void setSelectedCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void insertNewTodoItem(String title) {
    final todo = TodosCompanion(
        title: Value(title),
        completed: Value(false),
        category: _selectedCategory != null
            ? Value(_selectedCategory.id)
            : Value.absent());
    todosDao.insertTodo(todo);
  }

  Stream<List<TodoWithCategory>> watchTodosInCategory() {
    return todosDao.watchTodosInCategory(_selectedCategory,
        hideCompleted: hideCompleted);
  }
}
