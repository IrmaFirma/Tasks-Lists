import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/Lists.dart';

class ListsTile extends StatelessWidget {
  ListsTile({@required this.list, this.onTap});

  final Lists list;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0xFFDADADA)
      ),
      child: ListTile(
        title: Text(
          list.name,
          style: TextStyle(
            color:  Color(0xFF0F1020),
          ),
        ),
        onTap: onTap,
        trailing: Icon(
          Icons.chevron_right,
          color:  Color(0xFF0F1020),
        ),
      ),
    );
  }
}
