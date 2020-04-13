import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:more_todo/dabase_provider.dart';
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
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.add_circle),
            color: Colors.blue,
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
    var databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    databaseProvider.insertNewTodoItem(input).then((_) {
      _resetValuesAfterSubmit();
    }).catchError(
      (e) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid data! Todo item should not be empty or too long!',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        );
      },
      test: (e) => e is InvalidDataException,
    );
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
