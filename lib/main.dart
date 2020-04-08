import 'package:flutter/material.dart';
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
            return _buildItem(context, item);
          },
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, Todo item) {
    return ListTile(title: Text(item.title));
  }
}
