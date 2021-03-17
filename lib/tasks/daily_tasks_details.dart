import 'package:flutter/foundation.dart';
import 'package:todo_app/tasks/task_list.dart';


/// Temporary model class to store the time tracked and pay for a job
class ListDetails {
  ListDetails({
    @required this.name,
  });
  final String name;
  //TODO: Add comment

}

/// Groups together all jobs/entries on a given day
class DailyListsDetails {
  DailyListsDetails({@required this.date, @required this.listsDetails});
  final DateTime date;
  final List<ListDetails> listsDetails;


  /// splits all entries into separate groups by date
  static Map<DateTime, List<TaskLists>> _tasksByDate(List<TaskLists> tasks) {
    Map<DateTime, List<TaskLists>> map = {};
    for (var taskLists in tasks) {
      final taskDayStart = DateTime(taskLists.task.start.year,
          taskLists.task.start.month, taskLists.task.start.day);
      if (map[taskDayStart] == null) {
        map[taskDayStart] = [taskLists];
      } else {
        map[taskDayStart].add(taskLists);
      }
    }
    return map;
  }

  /// maps an unordered list of EntryJob into a list of DailyJobsDetails with date information
  static List<DailyListsDetails> all(List<TaskLists> tasks) {
    final byDate = _tasksByDate(tasks);
    List<DailyListsDetails> list = [];
    for (var date in byDate.keys) {
      final tasksByDate = byDate[date];
      final byLists = _listsDetails(tasksByDate);
      list.add(DailyListsDetails(date: date, listsDetails: byLists));
    }
    return list.toList();
  }

  /// groups entries by job
  static List<ListDetails> _listsDetails(List<TaskLists> tasks) {
    Map<String, ListDetails> listDuration = {};
    for (var taskLists in tasks) {
      final task = taskLists.task;
      if (listDuration[task.listId] == null) {
        listDuration[task.listId] = ListDetails(
          name: taskLists.list.name,
        );
      } else {
      }
    }
    return listDuration.values.toList();
  }
}