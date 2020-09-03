import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat_rooms/firebase/auth.dart';
import 'package:free_chat_rooms/firebase/firebase_methods.dart';
import 'package:free_chat_rooms/firebase/user.dart';
import 'package:free_chat_rooms/screens/chat_screen.dart';
import 'package:free_chat_rooms/utilits/app_bar.dart';
import 'package:free_chat_rooms/utilits/drawer.dart';
import 'package:free_chat_rooms/utilits/size.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

String searchStatement = '';

class PeopleScreen extends StatefulWidget {
  static const id = 'poeple_screen';
  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  bool showMPH = false;
  @override
  void initState() {
    super.initState();
    Auth.currentUser();
    searchStatement = '';
  }

  searching(String value) {
    setState(() {
      searchStatement = value;
    });
  }

  changeShowMPH() {
    setState(() {
      showMPH = !showMPH;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showMPH,
      child: Scaffold(
        drawer: MyMenu(
          showMPH: changeShowMPH,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              AppBarCustomize(
                searching: searching,
              ),
              PeopleStream(),
            ],
          ),
        ),
      ),
    );
  }
}

class PeopleStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseMethods.getPeople(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final currentUser = Auth.loginUser.email;
        final users = snapshot.data.documents.reversed;

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
                    newMessage: {
                      'lastMsg': user.data['lastMsg'],
                      'new': user.data['new'],
                    },
                  ),
                );
              }
            } else {
              userWidgets.add(
                UserView(
                  user: User(user.data),
                  newMessage: {
                    'lastMsg': user.data['lastMsg'],
                    'new': user.data['new'],
                  },
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
  Map newMessage;

  UserView({this.user, this.newMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.01),
      child: ListTile(
        title: Text(user.userName),
        subtitle:
            //  newMessage['new']?
            Row(
          children: <Widget>[
            Text(newMessage['lastMsg']),
            newMessage['new']
                ? CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: width * 0.01,
                  )
                : Container(),
          ],
        )
        // : null
        ,
        leading: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: user.picture,
              radius: width * 0.08,
            ),
            Container(
              width: width * 0.04,
              height: width * 0.04,
              margin: EdgeInsets.only(left: 40, top: 40),
              child: FutureBuilder(
                future: FirebaseMethods.getActiveStatus(user.email),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      decoration: BoxDecoration(
                        color: snapshot.data == "offline"
                            ? Colors.grey
                            : Colors.green,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
        trailing: Text(
          user.dateTime.toDate().toString().substring(0, 16),
          style: TextStyle(fontSize: 9),
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
