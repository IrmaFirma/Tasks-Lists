import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/platform_alert-dialog.dart';
import 'package:todo_app/components/platform_exception_dialog.dart';
import 'package:todo_app/models/Lists.dart';
import 'package:todo_app/services/database.dart';

class AddEditListPage extends StatefulWidget {
  AddEditListPage({@required this.database, this.list});

  final Database database;
  final Lists list;


  static Future<void> show(BuildContext context, {Lists record}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => AddEditListPage(database: database, list: record),
        fullscreenDialog: true));
  }

  @override
  _AddEditListPageState createState() => _AddEditListPageState();
}

class _AddEditListPageState extends State<AddEditListPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _comment;

  //Color picker
  Color pickerColor = Colors.deepPurpleAccent;
  Color currentColor = Colors.deepPurpleAccent;
  void changeColor(Color color) => setState(() => currentColor = color);

  @override
  void initState() {
    super.initState();
    if (widget.list != null) {
      _name = widget.list.name;
      _comment = widget.list.comment;
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSave()) {
      try {
        final lists = await widget.database.listsStream().first;
        final allNames = lists.map((list) => list.name).toList();
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final list = Lists(name: _name);
          await widget.database.setList(list);
          Navigator.of(context).pop();
        }
      } catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.list == null ? 'New List' : 'Edit List',
        ),
        actions: [
          FlatButton(
            child: Text('Save',
                style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: _submit,
          ),
        ],
        backgroundColor: Colors.indigo,
        elevation: 2,
      ),
      body: _buildContent(),
      backgroundColor: Color(0xFFDADADA),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 220, left: 16, right: 16),
        child: Card(
          color: Color(0xFFeeeeee),
          child:
              Padding(padding: const EdgeInsets.all(30), child: _buildForm()),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren()),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      Icon(Icons.list, color: currentColor, size: 50),
      TextFormField(
        textAlign: TextAlign.center,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: 'List name',
        ),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can not be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        maxLines: 1,
        decoration: InputDecoration(
          labelText: 'Comment',
        ),
        initialValue: _comment,
        onSaved: (value) => _comment = value,
      ),
      SizedBox(height: 15),
      RaisedButton(
          child: const Text('Select a color of your list'),
          color: currentColor,
          textColor: useWhiteForeground(currentColor)
              ? const Color(0xffffffff)
              : const Color(0xff000000),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Select'),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: currentColor,
                      onColorChanged: changeColor,
                    ),
                  ),
                );
              },
            );
          }),
    ];
  }
}
