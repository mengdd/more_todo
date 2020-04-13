import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:more_todo/dabase_provider.dart';
import 'package:more_todo/data/categories_dao.dart';
import 'package:more_todo/data/todo_database.dart';
import 'package:more_todo/data/todo_with_category.dart';
import 'package:more_todo/data/todos_dao.dart';
import 'package:more_todo/ui/new_category_input_widget.dart';
import 'package:more_todo/ui/new_todo_input_widget.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
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
        onTap: () {
          Navigator.pop(context);
        },
      );
    } else {
      Category category = categories[index - 2];
      return ListTile(
        leading: Icon(Icons.inbox),
        title: Text(category.name),
        onTap: () {
          Navigator.pop(context);
        },
      );
    }
  }

  Widget _buildList(BuildContext context) {
    TodosDao todosDao =
        Provider.of<DatabaseProvider>(context, listen: false).todosDao;
    return StreamBuilder(
      stream: todosDao.watchAllTodos(),
      builder: (BuildContext context,
          AsyncSnapshot<List<TodoWithCategory>> snapshot) {
        final todosWithCategory = snapshot.data ?? List();
        return ListView.builder(
          itemCount: todosWithCategory.length,
          itemBuilder: (BuildContext context, int index) {
            final item = todosWithCategory[index];
            return _buildItem(context, item, todosDao);
          },
        );
      },
    );
  }

  Widget _buildItem(
      BuildContext context, TodoWithCategory item, TodosDao todosDao) {
    return Slidable(
      actionExtentRatio: 0.2,
      actionPane: SlidableDrawerActionPane(),
      child: CheckboxListTile(
        title: Text(item.todo.title),
        value: item.todo.completed,
        onChanged: (newValue) {
          todosDao.updateTodo(item.todo.copyWith(completed: newValue));
        },
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () {},
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () {},
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.remove,
          onTap: () {
            todosDao.deleteTodo(item.todo);
          },
        ),
      ],
    );
  }
}
