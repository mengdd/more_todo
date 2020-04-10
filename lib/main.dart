import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:more_todo/dabase_provider.dart';
import 'package:more_todo/data/todo_database.dart';
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
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
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
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Inbox'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  StreamBuilder<List<Todo>> _buildList(BuildContext context) {
    TodosDao todosDao =
        Provider.of<DatabaseProvider>(context, listen: false).todosDao;
    return StreamBuilder(
      stream: todosDao.watchAllTodos(),
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        final todos = snapshot.data ?? List();
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            final item = todos[index];
            return _buildItem(context, item, todosDao);
          },
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, Todo item, TodosDao todosDao) {
    return Slidable(
      actionExtentRatio: 0.2,
      actionPane: SlidableDrawerActionPane(),
      child: CheckboxListTile(
        title: Text(item.title),
        value: item.completed,
        onChanged: (newValue) {
          todosDao.updateTodo(item.copyWith(completed: newValue));
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
            todosDao.deleteTodo(item);
          },
        ),
      ],
    );
  }
}
