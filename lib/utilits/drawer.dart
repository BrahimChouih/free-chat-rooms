import 'package:flutter/material.dart';
import 'package:free_chat_rooms/firebase/auth.dart';
import 'package:free_chat_rooms/screens/edit_profile.dart';
import 'package:free_chat_rooms/utilits/about_us.dart';
import 'package:free_chat_rooms/utilits/constant.dart';
import 'package:free_chat_rooms/utilits/msg_wrong.dart';
import 'package:free_chat_rooms/utilits/size.dart';

class MyMenu extends StatelessWidget {
  MyMenu({this.showMPH});
  Function showMPH;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      child: SafeArea(
        child: Container(
          width: width * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            color: Colors.green.withOpacity(0.4),
          ),
          child: Column(
            children: <Widget>[
              Theme(
                data: ThemeData(primaryColor: Colors.transparent),
                child: UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: Auth.userInfo.picture,
                  ),
                  accountEmail: Text(Auth.loginUser.email),
                  accountName: Text(Auth.userInfo.userName),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DrawerItem(
                      text: 'Edit My Profile',
                      icon: Icons.edit,
                      onPressed: () {
                        Navigator.of(context).pushNamed(EditProfile.id);
                      },
                      shadowColor: Colors.yellow,
                    ),
                    DrawerItem(
                      text: 'Delete this account',
                      icon: Icons.remove_circle_outline,
                      onPressed: () async {
                        showMPH();
                        await deleteAccountMsg(context);
                      },
                      shadowColor: Colors.red,
                    ),
                    DrawerItem(
                      text: 'About Us',
                      icon: Icons.info_outline,
                      onPressed: () {
                        aboutUs(context);
                      },
                      shadowColor: colorGradient[1],
                    ),
                    DrawerItem(
                      text: 'Log Out',
                      icon: Icons.exit_to_app,
                      onPressed: () {
                        Auth.signOut(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPressed;
  final Color shadowColor;

  DrawerItem({
    this.text,
    this.icon,
    this.onPressed,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        height: height * 0.06,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: shadowColor != null ? shadowColor : colorGradient[0],
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(text),
            SizedBox(
              width: width * 0.01,
            ),
            Icon(
              icon,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
