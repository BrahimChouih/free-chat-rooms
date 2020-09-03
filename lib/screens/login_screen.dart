import 'package:free_chat_rooms/firebase/auth.dart';
import 'package:free_chat_rooms/firebase/firebase_methods.dart';
import 'package:free_chat_rooms/screens/people_screen.dart';
import 'package:free_chat_rooms/utilits/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:free_chat_rooms/utilits/msg_wrong.dart';
import 'package:free_chat_rooms/utilits/size.dart';
import '../utilits/curve.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  static const idSignUp = 'signup_screen';
  final String mode;

  LoginScreen({this.mode});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  String passwordConfirm;
  bool showMPH = false;

  changeShowMPH(bool value) {
    setState(() {
      showMPH = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: showMPH,
        child: SafeArea(
          child: Container(
            height: height,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
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
                      SizedBox(height: height * 0.05),
                      loginOption(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'By Brahim CHOUIH',
                              style: kSignWithTextStyle,
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
      ),
    );
  }

  Card loginOption() {
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
            Image.asset(
                "assets/icons/${widget.mode == "sign up" ? "people_plus" : "people"}.png",
                height: height * 0.04),
            SizedBox(height: height * 0.03),
            myTextField("Email"),
            myTextField("Password"),
            widget.mode == "sign up"
                ? myTextField("Confirm Password")
                : Container(),
            InkWell(
              onTap: () async {
                try {
                  if (widget.mode == "sign up") {
                    if (password == passwordConfirm) {
                      changeShowMPH(true);

                      await Auth.signUp(email, password, catchError: (e) {
                        changeShowMPH(false);
                        msgWrong(context, msg: e, onPressed: () {
                          Navigator.pop(context);
                        });
                      });
                    } else {
                      msgWrong(
                        context,
                        msg: 'password in coract',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      );
                    }
                  } else {
                    changeShowMPH(true);
                    await Auth.signIn(email, password, catchError: (e) {
                      changeShowMPH(false);
                      msgWrong(context, msg: e, onPressed: () {
                        Navigator.pop(context);
                      });
                    });
                  }
                  user = await SharedPreferences.getInstance();
                  user.setString('email', email);
                  user.setString('password', password);
                  user.setBool('logged', true);

                  /// for Auth.loginUser != null
                  await Auth.currentUser();

                  if (Auth.loginUser != null) {
                    //// Navigating to chat room

                    //// for Auth.userInfo != null
                    await FirebaseMethods.initUser();

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        PeopleScreen.id, (Route<dynamic> route) => false);
                  }
                } catch (e) {
                  print(e);
                  msgWrong(context, msg: e, onPressed: () {
                    Navigator.pop(context);
                  });
                }
              },
              highlightColor: Colors.transparent,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                width: width * 0.3,
                height: height * 0.05,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colorGradient,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                    child: widget.mode == "sign up"
                        ? Text("SIGN UP")
                        : Text("SIGN IN")),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${widget.mode == "sign up" ? "You" : "Don't"} have an account ?",
                    style: kSignWithTextStyle,
                  ),
                  Text("  "),
                  InkWell(
                    onTap: () {
                      widget.mode == "sign up"
                          ? Navigator.of(context).pushNamed(LoginScreen.id)
                          : Navigator.of(context)
                              .pushNamed(LoginScreen.idSignUp);
                    },
                    child: Text(
                        widget.mode == "sign up" ? "Sign In" : "Sign Up",
                        style: kSignUpInStyle),
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Container myTextField(String hint) {
    return Container(
      height: height * 0.07,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.1,
        vertical: height * 0.015,
      ),
      child: Theme(
        data: ThemeData().copyWith(primaryColor: Color(0xff49FF09)),
        child: TextField(
          keyboardType: hint == 'Email' ? TextInputType.emailAddress : null,
          obscureText: hint != 'Email',
          onChanged: (value) {
            if (hint == 'Email') {
              email = value;
            } else if (hint == 'Password') {
              password = value;
            } else {
              passwordConfirm = value;
            }
          },
          cursorColor: Color(0xff49FF09),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
