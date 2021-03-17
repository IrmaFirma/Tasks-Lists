import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/keys.dart';
import 'package:todo_app/components/list_items_builder.dart';
import 'package:todo_app/components/platform_alert-dialog.dart';
import 'package:todo_app/components/platform_exception_dialog.dart';
import 'package:todo_app/components/strings.dart';
import 'package:todo_app/home/AddEditListPage.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/models/Lists.dart';
import 'package:todo_app/tasks_lists/task_list_page.dart';

import 'ListsTile.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthService auth = Provider.of<AuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _delete(BuildContext context, Lists list) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteList(list);
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Widget _buildLists(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Lists>>(
      stream: database.listsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Lists>(
          snapshot: snapshot,
          itemBuilder: (context, list) => Dismissible(
            key: Key('list-${list.id}'),
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.red
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, list),
            child: ListsTile(
              list: list,
              onTap: () => ListsTaskPage.show(context, list),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          FlatButton(
            key: Key(Keys.logout),
            child: Text(
              Strings.logout,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 100),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xFF7353BA)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 100,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xFFdeb1e0)),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                width: 370,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Color(0xFFc5a7c9)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.only(right: 240),
                  child: Text(
                    'My Lists',
                    style: TextStyle(fontSize: 30, color: Colors.indigo),
                  )),
              SizedBox(
                height: 10,
              ),
              _buildLists(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () => AddEditListPage.show(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
