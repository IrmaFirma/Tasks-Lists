import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/models/Lists.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/tasks/daily_tasks_details.dart';
import 'package:todo_app/tasks/task_list.dart';
import 'package:todo_app/tasks/tasks_list_tile.dart';
import 'package:todo_app/tasks_lists/format.dart';

import 'Task.dart';

//TODO: Refactor for your needs
class TasksBloc {
  TasksBloc({@required this.database});
  final Database database;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  Stream<List<TaskLists>> get _allEntriesStream => Rx.combineLatest2(
    database.tasksStream(),
    database.listsStream(),
    _tasksListsCombiner,
  );

  static List<TaskLists> _tasksListsCombiner(
      List<Task> tasks, List<Lists> lists) {
    return tasks.map((task) {
      final list = lists.firstWhere((list) => list.id == task.listId);
      return TaskLists(task, list);
    }).toList();
  }

  /// Output stream
  Stream<List<TasksListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<TasksListTileModel> _createModels(List<TaskLists> allEntries) {
    final allDailyListsDetails = DailyListsDetails.all(allEntries);


    return <TasksListTileModel>[
      TasksListTileModel(
        leadingText: 'All Entries',
        middleText: '',
        trailingText: ''
      ),
      for (DailyListsDetails dailyListsDetails in allDailyListsDetails) ...[
        TasksListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyListsDetails.date),
          middleText: '',
          trailingText: ''
        ),
        for (ListDetails listsDuration in dailyListsDetails.listsDetails)
          TasksListTileModel(
            leadingText: listsDuration.name,
            middleText: '',
            trailingText: '',
          ),
      ]
    ];
  }
}