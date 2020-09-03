import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:free_chat_rooms/firebase/auth.dart';
import 'package:free_chat_rooms/firebase/firebase_methods.dart';
import 'package:free_chat_rooms/screens/people_screen.dart';
import 'package:free_chat_rooms/screens/welcome_screen.dart';
import 'package:free_chat_rooms/utilits/constant.dart';
import 'package:free_chat_rooms/utilits/msg_wrong.dart';
import 'package:free_chat_rooms/utilits/size.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  static const id = 'loading_screen';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void getUser() async {
    user = await SharedPreferences.getInstance();
    if (user.getBool('logged') == null) {
      user.setBool('logged', false);
    }

    if (user.getBool('logged')) {
      try {
        final currentUser = await Auth.signIn(
            user.get('email'), user.getString('password'),
            catchError: (e) {});
        Auth.currentUser();
        await Future.delayed(Duration(seconds: 2));
        if (currentUser != null) {
          await FirebaseMethods.initUser();
          Navigator.of(context).pushReplacementNamed(PeopleScreen.id);
        } else {
          Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
        }
      } catch (e) {
        msgWrong(
          context,
          msg: e,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
          },
        );
      }
    } else {
      Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitSquareCircle(
            color: Color(0xff49FF09),
            size: 80,
          ),
          SizedBox(height: height * 0.03),
          Text(
            'By Brahim CHOUIH',
            style: kSignWithTextStyle,
          ),
        ],
      ),
    );
  }
}
