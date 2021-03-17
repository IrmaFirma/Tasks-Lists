import 'package:flutter/material.dart';

import 'custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    Key key,
    String text,
    bool loading = false,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Color(0xFF885b5f),
          textColor: Colors.black87,
          loading: loading,
          onPressed: onPressed,
        );
}
