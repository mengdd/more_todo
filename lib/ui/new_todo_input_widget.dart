import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:more_todo/data/todo_database.dart';
import 'package:provider/provider.dart';

class NewTodoInput extends StatefulWidget {
  const NewTodoInput({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewTodoInputState();
}

class _NewTodoInputState extends State<NewTodoInput> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'New Todo'),
              onSubmitted: (input) {
                _insertNewTodoItem(input, context);
              },
            ),
          ),
          RaisedButton(
            child: Text('Add'),
            onPressed: () {
              _insertNewTodoItem(controller.text, context);
            },
          ),
        ],
      ),
    );
  }

  void _insertNewTodoItem(String input, BuildContext context) {
    print('submitted! $input');
    TodoDatabase database = Provider.of<TodoDatabase>(context, listen: false);
    final todo = TodosCompanion(
      title: Value(input),
      completed: Value(false),
    );
    database.insertTodo(todo);
    _resetValuesAfterSubmit();
  }

  void _resetValuesAfterSubmit() {
    setState(() {
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
