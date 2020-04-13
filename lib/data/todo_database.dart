import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:more_todo/data/categories.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'todo_database.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 50)();

  TextColumn get content => text().nullable().named('description')();

  IntColumn get category => integer()
      .nullable()
      .customConstraint('NULL REFERENCES categories(id) ON DELETE CASCADE')();

  BoolColumn get completed => boolean().withDefault(Constant(false))();
}

@UseMoor(tables: [Todos, Categories])
class TodoDatabase extends _$TodoDatabase {
  // we tell the database where to store the data with this constructor
  TodoDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          print('migration from $from to $to');
          if (from == 1) {
            print('do migration from 1');
            migrator.deleteTable(todos.actualTableName);
            migrator.createTable(todos);
            migrator.createTable(categories);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}
