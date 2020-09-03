import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat_rooms/firebase/user.dart';
import 'package:free_chat_rooms/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_methods.dart';

SharedPreferences user;

class Auth {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static Firestore _firestore = Firestore.instance;
  static FirebaseUser loginUser;

  String email;
  String password;
  static var user;
  static User userInfo;

  static Future signIn(String email, String password,
      {Function catchError}) async {
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return user;
    } catch (e) {
      catchError(e);
      print(e);
    }
  }

  static Future signUp(String email, String password,
      {Function catchError}) async {
    try {
      user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        String userNameEmail;
        int i = email.indexOf('@');
        userNameEmail = email.substring(0, i);
        await _firestore.collection("users").document(email).setData({
          'email': email,
          'date': Timestamp.now(),
          'userName': userNameEmail,
          'picture': ''
        });
        _firestore
            .collection("users")
            .document(email)
            .collection('friends')
            .reference();
        return user;
      }
    } catch (e) {
      catchError(e);
      print(e);
    }
  }

  static signOut([BuildContext context]) {
    _auth.signOut();
    if (context != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          WelcomeScreen.id, (Route<dynamic> route) => false);
    }

    currentUser();
  }

  static currentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loginUser = user;
      await FirebaseMethods.initUser();
    }
  }

  static deleteAccount() async {
    await deleteAccountInfo();
    try {
      loginUser.delete();
    } catch (e) {
      print('delete user');
      print(e);
    }
  }

  static deleteAccountInfo() async {
    //////////////// add to users deleted
    try {
      await _firestore
          .collection('usersDeleted')
          .document(userInfo.email)
          .setData(
        {
          'email': userInfo.email,
          'userName': userInfo.userName,
          'date': Timestamp.now(),
        },
      );
    } catch (e) {
      print('add to users deleted');
      print(e);
    }

    ////////// delete all messages
    try {
      await FirebaseMethods.deleteAllMessages();
    } catch (e) {
      print('delete all messages');
      print(e);
    }

    ////////////////// delete user from users
    try {
      await _firestore
          .collection('users/${userInfo.email}/friends')
          .getDocuments()
          .then((onValue) {
        onValue.documents.forEach((f) {
          _firestore
              .collection('users/${f.data['email']}/friends')
              .document(userInfo.email)
              .delete();
          // for delete friends collection so delete this user
          f.reference.delete();
        });
      });

      await _firestore.collection("users").document(userInfo.email).delete();
    } catch (e) {
      print('delete user from users');
      print(e);
    }

    /////////// delete picture
    try {
      await FirebaseStorage.instance.ref().child(userInfo.email).delete();
    } catch (e) {
      print('delete picture');
      print(e);
    }
  }
}
