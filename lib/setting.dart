import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  var _isAdmin = false;

  @override
  void initState() {
    checkAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: <Widget>[
        FittedBox(
          child: Image.asset(
            'assets/loginsplash.png',
            width: 400,
            height: 380,
          ),
          fit: BoxFit.fill,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(80.0, 15.0, 80.0, 0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      minimumSize: Size(50, 50),
                      shape: shape,
                    ),
                    child: Text(
                      "Update Personal Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/userProfile");
                    },
                  )))
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(80.0, 15.0, 80.0, 0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    minimumSize: Size(50, 50),
                    shape: shape,
                  ),
                  child: Text(
                    "Change Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/changePassword');
                  },
                )),
          )
        ]),
        SizedBox(height: 0.0),
        !_isAdmin
            ? const SizedBox.shrink()
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(80.0, 15.0, 80.0, 0.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          minimumSize: Size(50, 50),
                          shape: shape,
                        ),
                        child: Text(
                          "Change Admin PIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/changeAdminPIN');
                        },
                      )),
                )
              ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(80.0, 10.0, 80.0, 0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      minimumSize: Size(50, 50),
                      shape: shape,
                    ),
                    child: Text(
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

  void checkAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('admin')!;
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();

    Navigator.popUntil(context, ModalRoute.withName("/"));
  }
}
