import 'package:flutter/material.dart';

class ButtonOne extends StatelessWidget {
  final Color color;
  final String text;
  final Function onTap;
  final Color textColor;

  const ButtonOne({
    Key key,
    this.text,
    this.color,
    this.onTap,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      textColor: textColor,
      padding: EdgeInsets.all(14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      onPressed: onTap,
    );
  }
}
