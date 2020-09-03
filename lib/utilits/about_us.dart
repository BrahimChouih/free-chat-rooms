import 'package:flutter/material.dart';

import 'constant.dart';

void aboutUs(context) {
  var dialog = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
      side: BorderSide(
        color: Color(0xff49FF09),
      ),
    ),
    elevation: 10,
    title: Text('About Us'),
    content: Text(
        '-Programmer : Brahim Chouih \n-fb: cristal.brahim  \n-email : brahim26chouih@gmail.com '),
    actions: <Widget>[
      FlatButton(
        child: Text(
          'ok',
          style: kSignUpInStyle,
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      )
    ],
  );
  showDialog(
      context: context,
      builder: (context) {
        return dialog;
      });
}
