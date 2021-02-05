import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:free_chat_rooms/firebase/auth.dart';
import 'package:free_chat_rooms/firebase/firebase_methods.dart';
import 'package:free_chat_rooms/utilits/constant.dart';
import 'package:free_chat_rooms/utilits/size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProfile extends StatefulWidget {
  static const id = 'edit_profile';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File picture;
  TextEditingController controller = TextEditingController();

  bool showMPH = false;

  changeShowMPH(bool value) {
    setState(() {
      showMPH = value;
    });
  }

  getImage(Mode mode) async {
    var image;
    try {
      if (mode == Mode.camera) {
        image = await ImagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 20);
      } else {
        image = await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 20);
      }
      setState(() {
        picture = image ?? image;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    controller.text = Auth.userInfo.userName;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showMPH,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(Auth.loginUser.email),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                await updateInformations();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            SizedBox(height: height * 0.03),
            CircleAvatar(
              radius: width * 0.2,
              backgroundImage:
                  picture == null ? Auth.userInfo.picture : FileImage(picture),
            ),
            SizedBox(height: height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera_enhance),
                  color: colorGradient[0],
                  onPressed: () async {
                    getImage(Mode.camera);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera_front),
                  color: colorGradient[1],
                  onPressed: () {
                    getImage(Mode.gallery);
                  },
                )
              ],
            ),
            SizedBox(height: height * 0.03),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: TextField(
                textAlign: TextAlign.center,
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'User Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateInformations() async {
    var urlImage = Auth.userInfo.urlPicture;
    String userName = Auth.userInfo.userName;
    changeShowMPH(true);
    if (picture != null) {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child(Auth.userInfo.email);
      StorageUploadTask task = storageReference.putFile(picture);
      await (await task.onComplete).ref.getDownloadURL().then((url) {
        print(url);
        urlImage = url;
      });
    }
    if (controller.text != '') {
      userName = controller.text;
    }
    await FirebaseMethods.updateUser({
      'email': Auth.userInfo.email,
      'date': Auth.userInfo.dateTime,
      'userName': userName,
      'picture': urlImage,
    });
    changeShowMPH(false);
    FirebaseMethods.initUser();
  }
}

enum Mode {
  camera,
  gallery,
}
