import 'package:flutter/material.dart';
import 'package:free_chat_rooms/screens/login_screen.dart';
import 'package:free_chat_rooms/utilits/constant.dart';
import 'package:free_chat_rooms/utilits/size.dart';

class Options extends StatelessWidget {
  final String title;

  Options(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.6,
      height: height * 0.07,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.1,
        vertical: height * 0.015,
      ),
      decoration: BoxDecoration(
        gradient: linearGradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {
          if (title == 'Sign In') {
            Navigator.of(context).pushNamed(LoginScreen.id);
          } else {
            Navigator.of(context).pushNamed(LoginScreen.idSignUp);
          }
        },
        child: Center(child: Text(title)),
      ),
    );
  }
}
