import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/components/date_time_picker.dart';
import 'package:todo_app/components/platform_exception_dialog.dart';
import 'package:todo_app/models/Lists.dart';
import 'package:todo_app/services/database.dart';

import 'Task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({@required this.database, @required this.list, this.task});

  final Lists list;
  final Task task;
  final Database database;

  static Future<void> show(
      {BuildContext context, Database database, Lists list, Task task}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            TaskPage(database: database, list: list, task: task),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DateTime _startDate;
  TimeOfDay _startTime;
  DateTime _endDate;
  TimeOfDay _endTime;
  String _title;
  String _notes;
  String _important;

  @override
  void initState() {
    super.initState();
    final start = widget.task?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.task?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _title = widget.task?.title ?? '';
    _notes = widget.task?.notes ?? 'No notes';
    _important = widget.task?.important ?? '';
  }

  Task _taskFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final id = widget.task?.id ?? documentIdFromCurrentDate();
    return Task(
        id: id,
        listId: widget.list.id,
        start: start,
        end: end,
        title: _title,
        notes: _notes,
        important: _important
    );
  }

  Future<void> _setTaskandDismiss(BuildContext context) async {
    try {
      final task = _taskFromState();
      await widget.database.setTask(task);
      Navigator.of(context).pop();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDADADA),
      appBar: AppBar(
        elevation: 2.0,
        title: Text(
          widget.list.name,
        ),
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          FlatButton(
            child: Text(
              widget.task != null ? 'Update' : 'Create',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setTaskandDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 630,
          padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildEndDate(),
                  _buildStartDate(),
                  _buildTitle(),
                  _buildNotes(),
                  _buildImportant(),
                  SizedBox(width: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate,
      selectedTime: _startTime,
      selectDate: (date) => setState(() => _startDate = date),
      selectTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate,
      selectedTime: _endTime,
      selectDate: (date) => setState(() => _endDate = date),
      selectTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildNotes() {
    return Container(
      width: 150,
      child: TextField(
        keyboardType: TextInputType.text,
        maxLength: 20,
        controller: TextEditingController(text: _title),
        decoration: InputDecoration(
          labelText: 'Title ',
          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        style: TextStyle(fontSize: 20, color: Colors.black),
        maxLines: null,
        onChanged: (title) {
          _title = title;
        },
      ),
    );
  }

  Widget _buildImportant() {
    return Container(
      width: 150,
      child: TextField(
        keyboardType: TextInputType.text,
        maxLength: 60,
        controller: TextEditingController(text: _notes),
        decoration: InputDecoration(
          labelText: 'Notes ',
          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        style: TextStyle(fontSize: 20, color: Colors.black),
        maxLines: 4,
        onChanged: (notes) {
          _notes = notes;
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: 150,
      child: TextField(
        keyboardType: TextInputType.text,
        maxLength: 60,
        controller: TextEditingController(text: _important),
        decoration: InputDecoration(
          labelText: 'Important ',
          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        style: TextStyle(fontSize: 20, color: Colors.black),
        maxLines: 4,
        onChanged: (important) {
          _important = important;
        },
      ),
    );
  }
}
