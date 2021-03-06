import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  _SettingPageState createState() => _SettingPageState();
}

/// Setting Page State to display the personal features for each user
class _SettingPageState extends State<SettingPage> {
  var _isAdmin = false;

  /// to ensure certain function is execute before page load for certain data
  @override
  void initState() {
    _checkAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    return Material(
        child: Container(
      color: mainTheme,
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: <Widget>[
        Positioned(
            top: 80,
            left: 30,
            child: Text("Settings",
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ))),
        Positioned(
          top: 40,
          right: -10,
          child: new Image.asset('assets/milkbottle.png', width: 140.0),
        ),
        Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    topLeft: Radius.circular(25.0)),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      80.0, 15.0, 80.0, 0.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: mainTheme,
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
                                      Navigator.of(context)
                                          .pushNamed("/userProfile");
                                    },
                                  )))
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      80.0, 15.0, 80.0, 0.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: mainTheme,
                                      minimumSize: Size(50, 50),
                                      shape: shape,
                                    ),
                                    child: Text(
                                      "View Child Details",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed("/childProfile");
                                    },
                                  )))
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    80.0, 15.0, 80.0, 0.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: mainTheme,
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
                                    Navigator.of(context)
                                        .pushNamed('/changePassword');
                                  },
                                )),
                          )
                        ]),
                    SizedBox(height: 0.0),
                    !_isAdmin
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          80.0, 15.0, 80.0, 0.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: mainTheme,
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
                                          Navigator.of(context)
                                              .pushNamed('/changeAdminPIN');
                                        },
                                      )),
                                )
                              ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      80.0, 10.0, 80.0, 0.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: secondaryTheme,
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
            ))
      ]),
    ));
  }

  /// Function is for checking whether user type is an admin
  ///
  /// Function will use [_isAdmin] variable to true or false based on the database data retrieved
  void _checkAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('admin')!;
    });
  }

  /// Function logs user out of the application and back to home page
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();

    /// Pop all navigation pages all in stack until root
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }
}
