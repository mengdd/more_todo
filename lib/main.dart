import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:more_todo/data/todo_database.dart';
import 'package:more_todo/ui/new_todo_input_widget.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => TodoDatabase(),
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

  StreamBuilder<List<Todo>> _buildList(BuildContext context) {
    TodoDatabase database = Provider.of<TodoDatabase>(context);
    return StreamBuilder(
      stream: database.watchAllTodos(),
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        final todos = snapshot.data ?? List();

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            final item = todos[index];
            return _buildItem(context, item, database);
          },
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, Todo item, TodoDatabase database) {
    return Slidable(
      actionExtentRatio: 0.2,
      actionPane: SlidableDrawerActionPane(),
      child: CheckboxListTile(
        title: Text(item.title),
        value: item.completed,
        onChanged: (newValue) {
          database.updateTodo(item.copyWith(completed: newValue));
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
            database.deleteTodo(item);
          },
        ),
      ],
    );
  }
}
