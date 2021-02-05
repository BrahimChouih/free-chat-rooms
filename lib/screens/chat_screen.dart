import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:free_chat_rooms/firebase/firebase_methods.dart';
import 'package:free_chat_rooms/firebase/user.dart';
import 'package:free_chat_rooms/utilits/constant.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  User me;
  User you;

  ChatScreen({this.me, this.you});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseMethods.readMessages(you: widget.you, lastMsg: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MessagesStream(
            me: widget.me,
            you: widget.you,
          ),
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    //Implement send functionality.
                    if (textController.text != '') {
                      FirebaseMethods.addMessage(
                        text: textController.text,
                        you: widget.you,
                      );
                      textController.clear();
                    }
                  },
                  child: Icon(
                    Icons.send,
                    color: Color(0xff49FF09),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  User me;
  User you;

  MessagesStream({this.me, this.you});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseMethods.getMessages(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final currentUser = me.email;
        final messages = snapshot.data.documents;
        for (var message in messages) {
          print(message.data);
        }
        List<MessageFromDB> messagesWidgets = [];
        String before;
        bool beforeIsThis;
        for (var message in messages) {
          if ((message.data['from'] == me.email &&
                  message.data['to'] == you.email) ||
              (message.data['to'] == me.email &&
                  message.data['from'] == you.email)) {
            beforeIsThis = message.data['from'] == before;
            print(" from : ${message.data['from']}");
            before = message.data['from'];
            messagesWidgets.add(
              MessageFromDB(
                text: message.data['text'],
                sender: message.data['from'],
                isMe: currentUser == message.data['from'],
                beforeIsThis: beforeIsThis,
              ),
            );
          }
        }
        if (messagesWidgets.isNotEmpty) {
          FirebaseMethods.readMessages(
              you: you, lastMsg: messagesWidgets.first.text);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            children: messagesWidgets.reversed.toList(),
          ),
        );
      },
    );
  }
}

class MessageFromDB extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final bool beforeIsThis;
  String userEmail;

  MessageFromDB({
    this.text,
    this.sender,
    this.isMe,
    this.beforeIsThis = false,
  });

  @override
  Widget build(BuildContext context) {
    userEmail = sender.substring(0, sender.indexOf('@')).toUpperCase();
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: isMe ? 30 : 8,
        right: isMe ? 8 : 30,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          beforeIsThis
              ? Container()
              : Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 13,
                  ),
                ),
          Container(
            decoration: BoxDecoration(
              color: isMe ? Color(0xff49FF09) : Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(isMe ? 30 : 0),
                topRight: Radius.circular(isMe ? 0 : 30),
              ),
              border: Border.all(
                color: isMe
                    ? Colors.green.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: isMe ? Color(0xff49FF09) : Colors.grey,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                  spreadRadius: isMe ? -2 : -8,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
