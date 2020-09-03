import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat_rooms/firebase/auth.dart';
import 'package:free_chat_rooms/firebase/firebase_methods.dart';
import 'package:free_chat_rooms/firebase/user.dart';
import 'package:free_chat_rooms/screens/chat_screen.dart';
import 'package:free_chat_rooms/utilits/size.dart';

String searchStatement = '';

class SearchScreen extends StatefulWidget {
  static const id = 'search_screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    searchStatement = '';
  }

  searching(String value) {
    setState(() {
      searchStatement = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.1,
                vertical: height * 0.015,
              ),
              child: Theme(
                data: ThemeData().copyWith(primaryColor: Color(0xff49FF09)),
                child: TextField(
                  onChanged: searching,
                  cursorColor: Color(0xff49FF09),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Searching...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            AllPeopleStream(),
          ],
        ),
      ),
    );
  }
}

class AllPeopleStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseMethods.getAllPeople(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final currentUser = Auth.loginUser.email;
        final users = snapshot.data.documents;

        List<Widget> userWidgets = [];
        for (var user in users) {
          if (user.data['email'] != currentUser) {
            if (searchStatement != '') {
              int searchLength =
                  searchStatement.length; // lenght search tatement
              int searchEmail = // length email for condition
                  searchLength < user.data['email'].toString().length
                      ? searchLength
                      : user.data['email'].toString().length;
              int searchUser = // length user name for condition
                  searchLength < user.data['userName'].toString().length
                      ? searchLength
                      : user.data['userName'].toString().length;
              if (searchStatement.toLowerCase() ==
                      user.data['email']
                          .toString()
                          .toLowerCase()
                          .substring(0, searchEmail) ||
                  searchStatement.toLowerCase() ==
                      user.data['userName']
                          .toString()
                          .toLowerCase()
                          .substring(0, searchUser)) {
                userWidgets.add(
                  UserView(
                    user: User(user.data),
                  ),
                );
              }
            } else {
              userWidgets.add(
                UserView(
                  user: User(user.data),
                ),
              );
            }
          } else {
            Auth.userInfo = User(user.data);
          }
        }
        return Expanded(
          child: ListView(
            children: userWidgets,
          ),
        );
      },
    );
  }
}

class UserView extends StatelessWidget {
  User user;

  UserView({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.01),
      child: ListTile(
        title: Text(user.userName),
        leading: CircleAvatar(
          backgroundImage: user.picture,
          radius: width * 0.08,
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ChatScreen(me: Auth.userInfo, you: user);
          }));
        },
      ),
    );
  }
}
