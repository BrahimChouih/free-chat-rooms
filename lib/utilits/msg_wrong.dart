import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat_rooms/firebase/auth.dart';

import 'constant.dart';

Widget msgWrong(context, {var msg, Function onPressed}) {
  if (msg.toString() ==
      'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)') {
    msg = 'The email address is already in use by another account';
  } else if (msg.toString() ==
      'PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)') {
    msg =
        'A network error (such as timeout, interrupted connection or unreachable host) has occurred';
  } else if (msg.toString() ==
      'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)') {
    msg = 'The password is invalid please try again';
  } else if (msg.toString() ==
      'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)') {
    msg =
        'There is no user record corresponding to this identifier. The user may have been deleted';
  } else if (msg.toString() ==
      'PlatformException(ERROR_WEAK_PASSWORD, The given password is invalid. [ Password should be at least 6 characters ], null)') {
    msg =
        'The given password is invalid. ( Password should be at least 6 characters )';
  }else if (msg.toString() == "'package:firebase_auth/src/firebase_auth.dart': Failed assertion: line 61 pos 12: 'email != null': is not true."){
msg = 'Please type your email and password !';
  }
  var dialog = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
      side: BorderSide(
        color: Color(0xff49FF09),
      ),
    ),
    elevation: 10,
    title: Text('Wrong'),
    content: Text(msg.toString()),
    actions: <Widget>[
      FlatButton(
        child: Text(
          'ok',
          style: kSignUpInStyle,
        ),
        onPressed: onPressed,
      )
    ],
  );
  showDialog(
      context: context,
      builder: (context) {
        return dialog;
      });
}

deleteAccountMsg(context) async{
  var dialog = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
      side: BorderSide(
        color: Color(0xff49FF09),
      ),
    ),
    elevation: 10,
    title: Text('Wait'),
    content: Text('Do you want delete your account ????'),
    actions: <Widget>[
      FlatButton(
        child: Text(
          'Yes',
          style: kSignUpInStyle,
        ),
        onPressed: ()async {
          Navigator.pop(context);
          await Auth.deleteAccount();
          Auth.signOut(context);
        },
      ),
      FlatButton(
        child: Text(
          'No',
          style: kSignUpInStyle,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
  await showDialog(
      context: context,
      builder: (context) {
        return dialog;
      });
}
