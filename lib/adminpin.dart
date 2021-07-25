import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Declaring Admin Pin Page as an stateful widget
class ChangePINPage extends StatefulWidget {
  @override
  _ChangePINPageState createState() => _ChangePINPageState();
}

/// Change Admin Pin Page State for changing of admin pin where required.
class _ChangePINPageState extends State<ChangePINPage> {
  final _userReference = FirebaseFirestore.instance.collection('user');

  /// text field variables
  var _oldPIN, _newPIN;

  /// Password Regex Expression
  RegExp passwordRegExp = new RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  final _formKey = GlobalKey<FormState>();
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            color: mainTheme,
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: <Widget>[
              Positioned(
                  top: 80,
                  left: 30,
                  child: Text("Change\nAdministrator PIN",
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
                      height: MediaQuery.of(context).size.height * 0.77,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            topLeft: Radius.circular(25.0)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    40.0, 0.0, 40.0, 20.0),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey,
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(25),
                                      ),
                                    ),
                                    labelText: 'Old PIN',
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter Old PIN';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() => _oldPIN = val.trim());
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    40.0, 0.0, 40.0, 20.0),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey,
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(25),
                                      ),
                                    ),
                                    labelText: 'New PIN',
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Enter New PIN';
                                    } else if (!passwordRegExp.hasMatch(val)) {
                                      return 'Enter a PIN with at least 8 characters, Lower case, Upper case, alphanumeric and special case letter';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() => _newPIN = val.trim());
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    40.0, 0.0, 40.0, 5.0),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey,
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(25),
                                      ),
                                    ),
                                    labelText: 'Confirm New PIN',
                                  ),
                                  validator: (val) => val != _newPIN
                                      ? 'Password does not match'
                                      : null,
                                ),
                              ),
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                80.0, 20.0, 80.0, 0.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: mainTheme,
                                                minimumSize: Size(50, 50),
                                                shape: shape,
                                              ),
                                              child: new Text(
                                                "Change Admin PIN",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _setNewPIN(_oldPIN, _newPIN);
                                                }
                                              },
                                            )))
                                  ]),
                            ]),
                      )))
            ])));
  }

  /// Set new Admin Pin firstly by comparing current pin with the existing pin
  /// in the firebase and change if it matches.
  ///
  /// Accepts [currentPIN] : the current admin pin stored in firebase,
  /// [newPIN] : the new admin pin to change to
  void _setNewPIN(String currentPIN, String newPIN) async {
    /// Retrieve hashed adminPin and user Key stored in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var adminPin = prefs.getString('adminPin').toString();
    var firebaseKey = prefs.getString('firebaseKey');

    /// Convert and hash the current pin entered by user for matching with the pin in SharedPreferences
    var currentPINBytes = utf8.encode(currentPIN);
    var currentHashedPin = sha256.convert(currentPINBytes).toString();

    /// If the hashed pin in SharedPreferences matches the hashed pin input, update record
    if (adminPin == currentHashedPin) {
      /// Convert and hash the new pin entered by user to update SharedPreferences and firebase
      var newPINBytes = utf8.encode(newPIN);
      var newHashedPin = sha256.convert(newPINBytes).toString();

      _userReference.doc(firebaseKey).update({
        'adminPin': newHashedPin.toString()
      });

      /// update the adminPin in the SharedPreference accordingly
      prefs.setString('adminPin', newHashedPin.toString());

      Fluttertoast.showToast(
          msg: "Successfully changed Admin PIN",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "PIN does not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
