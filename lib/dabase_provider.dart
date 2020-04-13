import 'package:flutter/material.dart';
import 'package:more_todo/data/categories_dao.dart';
import 'package:more_todo/data/todo_database.dart';
import 'package:more_todo/data/todos_dao.dart';

class DatabaseProvider extends ChangeNotifier {
  TodosDao _todosDao;
  CategoriesDao _categoriesDao;
  Category _selectedCategory;

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
}
