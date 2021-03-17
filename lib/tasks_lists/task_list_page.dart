import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/list_items_builder.dart';
import 'package:todo_app/components/platform_exception_dialog.dart';
import 'package:todo_app/home/AddEditListPage.dart';
import 'package:todo_app/models/Lists.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/tasks/Task.dart';
import 'package:todo_app/tasks/task_page.dart';
import 'package:todo_app/tasks_lists/task_list_item.dart';

class ListsTaskPage extends StatelessWidget {
  const ListsTaskPage({@required this.database, @required this.list});

  final Database database;
  final Lists list;

  static Future<void> show(BuildContext context, Lists list) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ListsTaskPage(database: database, list: list),
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context, Task task) async {
    try {
      await database.deleteTask(task);
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Lists>(
        stream: database.listStream(listId: list.id),
        builder: (context, snapshot) {
          final list = snapshot.data;
          final listName = list?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(listName),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () => AddEditListPage.show(
                    context,
                    record: list,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => TaskPage.show(
                      context: context, database: database, list: list),
                ),
              ],
            ),
            body: _buildContent(context, list),
          );
        });
  }

  Widget _buildContent(BuildContext context, Lists list) {
    return StreamBuilder<List<Task>>(
      stream: database.tasksStream(list: list),
      builder: (context, snapshot) {
        return ListItemsBuilder<Task>(
          snapshot: snapshot,
          itemBuilder: (context, task) {
            return DismissibleTaskListItem(
              key: Key('task-${task.id}'),
              task: task,
              list: list,
              onDismissed: () => _deleteTask(context, task),
              onTap: () => TaskPage.show(
                  context: context, database: database, task: task, list: list),
            );
          },
        );
      },
    );
  }
}
