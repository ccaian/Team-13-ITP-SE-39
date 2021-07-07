import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/changepassword.dart';
import 'package:growth_app/main.dart';
import 'package:growth_app/userprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var name;

  @override
  void initState() {
    super.initState();
    setUI();
  }

  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    return new Scaffold(
        body: new SingleChildScrollView(
      //padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
      child: Column(children: <Widget>[
        FittedBox(
          child: new Image.asset(
            'assets/healthcare.png',
            width: 400,
            height: 380,
          ),
          fit: BoxFit.fill,
        ),
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(80.0, 15.0, 80.0, 0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      minimumSize: Size(50, 50),
                      shape: shape,
                    ),
                    child: new Text(
                      "Update Personal Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => UserProfilePage()));
                    },
                  )))
        ]),
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(80.0, 15.0, 80.0, 0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    minimumSize: Size(50, 50),
                    shape: shape,
                  ),
                  child: new Text(
                    "Change Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ChangePasswordPage()));
                  },
                )),
          )
        ]),
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(80.0, 10.0, 80.0, 0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      minimumSize: Size(50, 50),
                      shape: shape,
                    ),
                    child: new Text(
                      "Logout",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      logout();
                    },
                  )))
        ])
      ]),
    ));
  }

  Future<void> setUI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');

    setState(() {});
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await FirebaseAuth.instance.signOut();

    Navigator.popUntil(
        context, ModalRoute.withName(Navigator.defaultRouteName));
  }
}
