import 'package:flutter/material.dart';
import 'package:todo_app/models/Lists.dart';
import 'package:todo_app/tasks/Task.dart';

import 'format.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    @required this.task,
    @required this.list,
    @required this.onTap,
  });

  final Task task;
  final Lists list;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Row(
                children: [
                  Checkbox(value: false, onChanged: (bool val) => print(val)),
                  _buildContents(context),
                ],
              )),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dayOfWeek = Format.dayOfWeek(task.start);
    final startDate = Format.date(task.start);
    final title = task.title;
    final notes = task.notes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(dayOfWeek, style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          SizedBox(width: 15.0),
          Text(startDate, style: TextStyle(fontSize: 18.0)),
        ]),
        Row(
          children: [Text(title, style: TextStyle(fontSize: 20.0))],
        ),
        Text(notes, style: TextStyle(fontSize: 15.0, color: Colors.grey)),
      ],
    );
  }
}

class DismissibleTaskListItem extends StatelessWidget {
  const DismissibleTaskListItem({
    this.key,
    this.task,
    this.list,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final Task task;
  final Lists list;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: TaskListItem(
        task: task,
        list: list,
        onTap: onTap,
      ),
    );
  }
}
