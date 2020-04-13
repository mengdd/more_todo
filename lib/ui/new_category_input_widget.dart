import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:more_todo/dabase_provider.dart';
import 'package:more_todo/data/categories_dao.dart';
import 'package:more_todo/data/todo_database.dart';
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
            iconSize: 30,
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
    CategoriesDao categoriesDao =
        Provider.of<DatabaseProvider>(context, listen: false).categoriesDao;

    categoriesDao.insertCategory(CategoriesCompanion(name: Value(input))).then(
      (_) {
        _resetValuesAfterSubmit();
      },
    ).catchError(
      (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              'Invalid data! Category should not be empty or too long!',
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
