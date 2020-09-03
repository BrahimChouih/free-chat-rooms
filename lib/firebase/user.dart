import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String email;
  String userName;
  var picture;
  Timestamp dateTime;
  String urlPicture;

  User(Map<String, dynamic> map) {
    fromMap(map);
  }

  fromMap(Map<String, dynamic> map) {
    this.email = map['email'];
    this.userName = map['userName'];
    this.dateTime = map['date'];
    this.urlPicture = map['picture'];
    if (map['picture'] == '') {
      this.picture = AssetImage("assets/images/person.png");
    } else {
      this.picture = NetworkImage(map['picture']);
    }
  }
}
