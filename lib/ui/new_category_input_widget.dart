import 'package:flutter/material.dart';
import 'package:more_todo/dabase_provider.dart';
import 'package:more_todo/data/todos_dao.dart';
import 'package:provider/provider.dart';

class NewCategoryInput extends StatefulWidget {
  const NewCategoryInput({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewCategoryInputState();
}

class _NewCategoryInputState extends State<NewCategoryInput> {
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
              decoration: InputDecoration(hintText: 'New Category'),
              onSubmitted: (input) {
                _insertNewCategory(input, context);
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.indigo,
            ),
            onPressed: () {
              _insertNewCategory(controller.text, context);
            },
          ),
        ],
      ),
    );
  }

  void _insertNewCategory(String input, BuildContext context) {
    print('submitted! $input');
    TodosDao todosDao =
        Provider.of<DatabaseProvider>(context, listen: false).todosDao;

    //TODO
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
