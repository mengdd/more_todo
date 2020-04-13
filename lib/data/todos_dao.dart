import 'package:moor/moor.dart';
import 'package:more_todo/data/categories.dart';
import 'package:more_todo/data/todo_database.dart';
import 'package:more_todo/data/todo_with_category.dart';

part 'todos_dao.g.dart';

// the _TodosDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [Todos, Categories])
class TodosDao extends DatabaseAccessor<TodoDatabase> with _$TodosDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  TodosDao(TodoDatabase db) : super(db);

  Future<List<Todo>> getAllTodos() => select(todos).get();

  Stream<List<TodoWithCategory>> watchAllTodos() {
    final query = select(todos).join([
      leftOuterJoin(categories, categories.id.equalsExp(todos.category)),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TodoWithCategory(
          todo: row.readTable(todos),
          category: row.readTable(categories),
        );
      }).toList();
    });
  }

  Future insertTodo(TodosCompanion todo) => into(todos).insert(todo);

  Future updateTodo(Todo todo) => update(todos).replace(todo);

  Future deleteTodo(Todo todo) => delete(todos).delete(todo);
}
