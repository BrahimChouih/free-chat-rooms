import 'package:flutter/material.dart';

const kSignWithTextStyle = TextStyle(
  color: Color(0xffA7A7A7),
  fontSize: 14,
);
const kSignUpInStyle = TextStyle(
  color: Color(0xff30B800),
  fontWeight: FontWeight.w300,
);

const colorGradient = [
  const Color(0xff00EDFF),
  const Color(0xff7FFF00),
];

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

var kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Color(0xff49FF09), width: 2.0),
  ),
);
