import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:free_chat_rooms/firebase/auth.dart';
import 'package:free_chat_rooms/firebase/user.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseMethods {
  static Firestore _firestore = Firestore.instance;
  static DatabaseReference _firebaseDatabse =
      FirebaseDatabase.instance.reference();

  static initUser() async {
    await _firestore
        .collection("users")
        .document(Auth.loginUser.email)
        .get()
        .then((onValue) {
      Auth.userInfo = User(onValue.data);
    });
    await FirebaseMethods.myActiveStatus();
  }

  static Stream<QuerySnapshot> getPeople() {
    return _firestore
        .collection("users")
        .document(Auth.userInfo.email)
        .collection('friends')
        .orderBy('date')
        .snapshots();
  }

  static Stream<QuerySnapshot> getAllPeople() {
    return _firestore.collection("users").orderBy('date').snapshots();
  }

  static updateUser(Map<String, dynamic> newInfo) async {
    await _firestore
        .collection('users')
        .document(Auth.loginUser.email)
        .setData(newInfo);
  }

  static Stream<QuerySnapshot> getMessages() {
    return _firestore.collection("messages").orderBy('date').snapshots();
  }

  static addMessage({User you, String text}) {
    _firestore.collection('messages').add({
      "text": text,
      'from': Auth.userInfo.email,
      'to': you.email,
      'date': Timestamp.now(),
    });
    String lastMsg = text.substring(0, text.length < 15 ? text.length : 15) +
        (text.length < 15 ? ' ' : '... ');
    _firestore
        .collection('users/${Auth.userInfo.email}/friends')
        .document(you.email)
        .setData({
      'email': you.email,
      'userName': you.userName,
      'picture': you.urlPicture,
      'date': Timestamp.now(),
      'lastMsg': lastMsg,
      'new': false,
    });
    _firestore
        .collection('users')
        .document(you.email)
        .collection('friends')
        .document(Auth.userInfo.email)
        .setData({
      'email': Auth.userInfo.email,
      'userName': Auth.userInfo.userName,
      'picture': Auth.userInfo.urlPicture,
      'date': Timestamp.now(),
      'lastMsg': lastMsg,
      'new': true,
    });
  }

  static readMessages({User you, String lastMsg}) async {
    int exists;
    User from;
    await _firestore
        .collection("users")
        .document(Auth.userInfo.email)
        .collection('friends')
        .where('email', isEqualTo: you.email)
        .getDocuments()
        .then((onValue) {
      exists = onValue.documents.length;
    });
    if (exists != 0) {
      await _firestore
          .collection('users')
          .document(you.email)
          .get()
          .then((onValue) {
        from = User(onValue.data);
      });
      await _firestore
          .collection('users/${Auth.userInfo.email}/friends')
          .document(you.email)
          .get()
          .then((onValue) {
        from.dateTime = onValue.data['date'];
      });
      _firestore
          .collection('users')
          .document(Auth.userInfo.email)
          .collection('friends')
          .document(from.email)
          .setData({
        'email': from.email,
        'userName': from.userName,
        'picture': from.urlPicture,
        'date': from.dateTime,
        'lastMsg':
            lastMsg.substring(0, lastMsg.length < 15 ? lastMsg.length : 15) +
                (lastMsg.length < 15 ? ' ' : '... '),
        'new': false,
      });
    }
  }

  static deleteMessage(id) {
    _firestore.collection('messages').document(id).delete();
  }

  static deleteAllMessages() async {
    await deleteAllMessagesFromOrTo('from');
    await deleteAllMessagesFromOrTo('to');
  }

  static deleteAllMessagesFromOrTo(String fromTo) async {
    await _firestore
        .collection('messages')
        .where(fromTo, isEqualTo: Auth.loginUser.email)
        .getDocuments()
        .then((onValue) {
      onValue.documents.forEach((f) {
        deleteMessage(f.documentID);
      });
    });
  }

  static myActiveStatus() {
    int index = Auth.loginUser.email.indexOf("@");
    var userFirestoreRef = _firestore
        .collection('status')
        .document(Auth.loginUser.email.substring(0, index));
    var userDBRef = _firebaseDatabse
        .child('status')
        .child(Auth.loginUser.email.substring(0, index));

    var userIsOnlineFirestor = {
      'status': 'online',
      'lastChanged': FieldValue.serverTimestamp(),
    };
    var userIsOfflineFirestor = {
      'status': 'offline',
      'lastChanged': FieldValue.serverTimestamp(),
    };

    var userIsOnlineDb = {
      'status': 'online',
      'lastChanged': ServerValue.timestamp,
    };
    var userIsOfflineDB = {
      'status': 'offline',
      'lastChanged': ServerValue.timestamp,
    };

    _firebaseDatabse.child('.info').child('connected').onValue.listen((onData) {
      if (onData.snapshot.value == false) {
        userFirestoreRef.setData(userIsOfflineFirestor);
      }
      userDBRef.onDisconnect().update(userIsOfflineDB).then((onValue) async {
        await userDBRef.update(userIsOnlineDb).catchError((e) {
          print(e);
        });
        await userFirestoreRef.setData(userIsOnlineFirestor).catchError((e) {
          print(e);
        });
      });
    });
  }

  static Future<String> getActiveStatus(String email) async {
    int index = email.indexOf('@');
    String status;
    await _firebaseDatabse
        .child('status')
        .child(email.substring(0, index))
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      status = values['status'];
      // print(values['status']);
    });
    return status;
  }
}
