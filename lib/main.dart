import 'package:flutter/material.dart';
import 'package:free_chat_rooms/screens/edit_profile.dart';
import 'package:free_chat_rooms/screens/loading_screen.dart';
import 'package:free_chat_rooms/screens/login_screen.dart';
import 'package:free_chat_rooms/screens/people_screen.dart';
import 'package:free_chat_rooms/screens/search_screen.dart';
import 'package:free_chat_rooms/screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Free Chat Rooms",
      theme: ThemeData(
        primaryColor: Color(0xff7FFF00),
        accentColor: Color(0xff7FFF00),
        fontFamily: 'Helveticaneue',
      ),
      initialRoute: LoadingScreen.id,
      routes: {
        LoadingScreen.id: (_) => LoadingScreen(),
        WelcomeScreen.id: (_) => WelcomeScreen(),
        LoginScreen.id: (_) => LoginScreen(
              mode: 'sign in',
            ),
        LoginScreen.idSignUp: (_) => LoginScreen(
              mode: 'sign up',
            ),
        EditProfile.id: (_) => EditProfile(),
        PeopleScreen.id: (_) => PeopleScreen(),
        SearchScreen.id: (_) => SearchScreen(),
      },
    );
  }
}
