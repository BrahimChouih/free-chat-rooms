import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat_rooms/screens/search_screen.dart';
import 'package:free_chat_rooms/utilits/size.dart';

class AppBarCustomize extends StatelessWidget {
  Function searching;

  AppBarCustomize({this.searching});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.filter_list),
                color: Color(0xff30B800),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          Container(
            width: width * 0.6,
            child: TextField(
              cursorColor: Color(0xff49FF09),
              decoration: InputDecoration(
                prefix: Icon(Icons.search),
                hintText: 'Search here',
              ),
              onChanged: (value) {
                searching(value);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            color: Color(0xff30B800),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
