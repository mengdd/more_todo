# more_todo

A to-do app written in Flutter.
To learn how Moor works.

## Moor
* [Moor github](https://github.com/simolus3/moor)
* [Moor website](https://moor.simonbinder.eu/)
* [package: moor_ffi](https://pub.dev/packages/moor_ffi)
* [Moor Getting Started](https://moor.simonbinder.eu/docs/getting-started/)

### Other Resources
* [Moor (Room for Flutter) #1 – Tables & Queries – Fluent SQLite Database](https://www.youtube.com/watch?v=zpWsedYMczM&feature=youtu.be)

This video uses moor_flutter but we are using moor_ffi. (newer).

### To generate code
```
flutter packages pub run build_runner build
```
or:
```
flutter packages pub run build_runner watch
```

## Changelog
### v0.1.0
A single screen of TODOs in a list.
To show the simplest usage of a local database.

![todo list in v0.1.0](./screenshots/todo-app-v0.1.0.png)

* Add: from the bottom input field.
* Delete: Slide and click the delete action.
* Update: Check/Uncheck the checkbox to mark the item as completed or not.
* Query: Watch all todos in the database and show them in the list.

### v0.2.0
Todos with Category.
Use foreign keys and join.
Do a database migration from the last version.

![categories in v0.2.0](./screenshots/todo-app-v0.2.0-categories.png)
![todo list in v0.2.0](./screenshots/todo-app-v0.2.0-todos.png)

* Show categories at drawer menu. Users can add a new category or delete a category.
* Todos without a category are put under 'Inbox'.
* If a category is deleted, all todos under it would be deleted too.
* A Switch button is shown (at the top) to hide all completed todos.
* Show error hint when trying to insert invalid data.
* Some UI refinements.