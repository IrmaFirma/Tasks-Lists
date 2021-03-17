import 'package:flutter/foundation.dart';

class Task {
  Task(
      {@required this.id,
      @required this.listId,
      @required this.start,
      @required this.end,
      @required this.title,
      @required this.notes,
      this.important});

  String id;
  String listId;
  DateTime start;
  DateTime end;
  String title;
  String notes;
  String important;

  factory Task.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    return Task(
        id: id,
        listId: value['listId'],
        start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
        end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
        title: value['title'],
        notes: value['notes'],
        important: value['important']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'listId': listId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'title': title,
      'notes': notes,
      'important': important
    };
  }
}
