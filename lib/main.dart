import 'package:flutter/material.dart';
import 'package:more_todo/dabase_provider.dart';
import 'package:more_todo/data/categories_dao.dart';
import 'package:more_todo/data/todo_database.dart';
import 'package:more_todo/data/todo_with_category.dart';
import 'package:more_todo/data/todos_dao.dart';
import 'package:more_todo/ui/new_category_input_widget.dart';
import 'package:more_todo/ui/new_todo_input_widget.dart';
import 'package:more_todo/ui/todo_item_widget.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DatabaseProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Text('Hide completed'),
              Consumer<DatabaseProvider>(
                builder: (BuildContext context,
                        DatabaseProvider databaseProvider, Widget child) =>
                    Switch(
                  value: databaseProvider.hideCompleted,
                  onChanged: (value) {
                    print('changed $value');
                    databaseProvider.hideCompleted = value;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildList(context),
          ),
          NewTodoInput(),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    CategoriesDao categoriesDao =
        Provider.of<DatabaseProvider>(context, listen: false).categoriesDao;
    return Drawer(
      child: StreamBuilder(
        stream: categoriesDao.watchAllCategories(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          List<Category> categories = snapshot.data ?? List();
          return ListView.builder(
            itemCount: categories.length + 2,
            itemBuilder: (BuildContext context, int index) {
              return _buildDrawerItem(context, categories, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, List<Category> categories, int index) {
    var databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    if (index == 0) {
      return DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'My Todos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            NewCategoryInput(),
          ],
        ),
      );
    } else if (index == 1) {
      return ListTile(
        leading: Icon(Icons.inbox),
        title: Text('Inbox'),
        selected: databaseProvider.selectedCategory == null,
        onTap: () {
          databaseProvider.setSelectedCategory(null);
          Navigator.pop(context);
        },
      );
    } else {
      Category category = categories[index - 2];
      return ListTile(
        leading: Icon(Icons.inbox),
        title: Text(category.name),
        selected: databaseProvider.selectedCategory == category,
        onTap: () {
          databaseProvider.setSelectedCategory(category);
          Navigator.pop(context);
        },
        onLongPress: () {
          _showDeleteCategoryDialog(context, databaseProvider, category);
        },
      );
    }
  }

  void _showDeleteCategoryDialog(BuildContext context,
      DatabaseProvider databaseProvider, Category category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('DELETE'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Do you want to delete this category?'),
            SizedBox(
              height: 8,
            ),
            Text(
              'All the items under this category would be gone.',
              style: TextStyle(color: Colors.redAccent),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(
              'YES',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              databaseProvider.deleteCategory(category);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, databaseProvider, child) => StreamBuilder(
        stream: databaseProvider.watchTodosInCategory(),
        builder: (BuildContext context,
            AsyncSnapshot<List<TodoWithCategory>> snapshot) {
          print('buid list for ${databaseProvider.selectedCategory}');
          final todosWithCategory = snapshot.data ?? List();
          return ListView.builder(
            itemCount: todosWithCategory.length,
            itemBuilder: (BuildContext context, int index) {
              final item = todosWithCategory[index];
              return _buildItem(context, item, databaseProvider.todosDao);
            },
          );
        },
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, TodoWithCategory item, TodosDao todosDao) {
    return TodoItemWidget(item, todosDao);
  }
}
