import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/Lists.dart';
import 'package:todo_app/services/APIPath.dart';
import 'package:todo_app/tasks/Task.dart';

import 'firestore_service.dart';

abstract class Database {
  Future<void> setList(Lists list);

  Stream<List<Lists>> listsStream();

  Stream<Lists> listStream({String listId});

  Future<void> deleteList(Lists list);

  Future<void> setTask(Task task);

  Future<void> deleteTask(Task task);

  Stream<List<Task>> tasksStream({Lists list});

}
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;



  @override
  Future<void> setList(Lists list) async =>
      await _service.setData(
        path: APIPath.path_list(uid, documentIdFromCurrentDate()),
        data: list.toMap(),
      );

  @override
  Future<void> deleteList(Lists list) async {  // delete where entry.recordId == record.recordId
    final allTasks = await tasksStream(list: list).first;
    for (Task task in allTasks) {
      if (task.listId == list.id) {
        await deleteTask(task);
      }
    }
    // delete record
    await _service.deleteData(path: APIPath.path_list(uid, list.id));}



  Stream<List<Lists>> listsStream() =>
      _service.collectionStream(
        path: APIPath.path_lists(uid),
        builder: (data, documentId) => Lists.fromMap(data, documentId),
      );

  @override
  Stream<Lists> listStream({String listId}) =>
      _service.documentStream(
          path: APIPath.path_list(uid, listId),
          builder: (data, documentId) => Lists.fromMap(data, documentId));

  @override
  Future<void> setTask(Task task) async =>
      await _service.setData(
        path: APIPath.task(uid: uid, taskId: task.id),
        data: task.toMap(),
      );

  @override
  Future<void> deleteTask(Task task) async =>
      await _service.deleteData(
          path: APIPath.task(uid: uid, taskId: task.id));

  @override
  Stream<List<Task>> tasksStream({Lists list}) =>
      _service.collectionStream<Task>(
        path: APIPath.tasks(uid: uid),
        queryBuilder: list != null
            ? (query) => query.where('listId', isEqualTo: list.id)
            : null,
        builder: (data, documentID) => Task.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

}
