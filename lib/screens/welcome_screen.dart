import 'package:flutter/material.dart';
import 'package:free_chat_rooms/utilits/componets.dart';
import 'package:free_chat_rooms/utilits/constant.dart';
import 'package:free_chat_rooms/utilits/curve.dart';
import 'package:free_chat_rooms/utilits/size.dart';
import 'package:free_chat_rooms/firebase/auth.dart';

class WelcomeScreen extends StatelessWidget {
  static const id = 'welcome';

  @override
  Widget build(BuildContext context) {
    user.clear();
    Auth.signOut();
    Auth.user = null;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          height: height,
          child: Center(
            child: Stack(
              children: <Widget>[
                MyCurve(),
                Column(
                  children: <Widget>[
                    SizedBox(height: height * 0.05),
                    Container(
                      width: width * 0.5,
                      height: height * 0.15,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    SizedBox(height: height * 0.1),
                    loginOption(context),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "By Brahim CHOUIH",
                                style: kSignWithTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.05)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card loginOption(context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 10,
      child: Container(
        width: width * 0.8,
        margin: EdgeInsets.symmetric(vertical: height * 0.02),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome in Free Chat Rooms',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: height * 0.04),
            Options("Sign In"),
            Options("Sign Up"),
            SizedBox(
              height: height * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}
