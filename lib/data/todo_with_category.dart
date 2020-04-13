import 'package:flutter/cupertino.dart';
import 'package:more_todo/data/todo_database.dart';

class TodoWithCategory {
  final Todo todo;
  final Category category;

  TodoWithCategory({@required this.todo, @required this.category});
}
