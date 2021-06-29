import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/parenthome.dart';
import 'package:growth_app/workerhome.dart';
import 'package:growth_app/workerselfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  var email;
  var firstName;
  var lastName;
  var mobileNumber;
  var userKey;
  var _buttonToggle = true;
  var _editToggle = false;

  @override
  void initState() {
    super.initState();
    retrieveData();
  }

  final _auth = FirebaseAuth.instance;
  final _userRef = FirebaseDatabase.instance.reference().child('user');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    return new Scaffold(
        body: new SingleChildScrollView(
            //padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
            child: Form(
      key: _formKey,
      child: Column(children: <Widget>[
        FittedBox(
          child: new Image.asset(
            'assets/loginsplash.png',
            width: 400,
            height: 380,
          ),
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
          child: TextFormField(
            controller: TextEditingController(text: firstName),
            enabled: _editToggle,
            decoration: InputDecoration(
              fillColor: Colors.grey,
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(25),
                ),
              ),
              labelText: 'First Name',
            ),
            validator: (val) => val!.isEmpty ? 'Enter First Name' : null,
            onChanged: (val) {
              setState(() => firstName = val);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
          child: TextFormField(
            controller: TextEditingController(text: lastName),
            enabled: _editToggle,
            decoration: InputDecoration(
              fillColor: Colors.grey,
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(25),
                ),
              ),
              labelText: 'Last Name',
            ),
            validator: (val) => val!.isEmpty ? 'Enter Last Name' : null,
            onChanged: (val) {
              setState(() => lastName = val);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
          child: TextFormField(
            controller: TextEditingController(text: mobileNumber),
            enabled: _editToggle,
            decoration: InputDecoration(
              fillColor: Colors.grey,
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(25),
                ),
              ),
              labelText: 'Mobile Number',
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            //
            validator: (val) {
              if (val!.isEmpty) {
                return 'Enter Mobile Number';
              } else if (val.length != 8) {
                return 'Please check if Mobile Number is correct';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() => mobileNumber = val);
            },
          ),
        ),
        SizedBox(height: 0.0),
        !_buttonToggle
            ? const SizedBox.shrink()
            : new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                minimumSize: Size(50, 50),
                                shape: shape,
                              ),
                              child: new Text(
                                "Edit Details",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                _editToggle = true;
                                hideButton();
                                print(_editToggle);
                              },
                            )))
                  ]),
        SizedBox(height: 0.0),
        _buttonToggle
            ? const SizedBox.shrink()
            : new Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          minimumSize: Size(50, 50),
                          shape: shape,
                        ),
                        child: new Text(
                          "Cancel",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          _editToggle = false;
                          hideButton();
                        },
                      )),
                )
              ]),
        SizedBox(height: 0.0),
        _buttonToggle
            ? const SizedBox.shrink()
            : new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                80.0, 10.0, 80.0, 0.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent,
                                minimumSize: Size(50, 50),
                                shape: shape,
                              ),
                              child: new Text(
                                "Update Details",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                _editToggle = false;
                                updateDetails();
                                hideButton();
                              },
                            )))
                  ])
      ]),
    )));
  }

  Future<void> retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');

    Query _userQuery = _userRef.orderByChild("email").equalTo(email);

    await _userQuery.once().then((DataSnapshot snapShot) {
      print(snapShot.value);
      // User profile exist in DB => to home page
      if (snapShot.value != null) {
        Map<dynamic, dynamic> values = snapShot.value;
        values.forEach((key, values) {
          setState(() {
            userKey = key;
            firstName = values['firstName'];
            lastName = values['lastName'];
            mobileNumber = values['mobile'];
          });
        });
      }
    });
  }

  updateDetails() {
    _userRef.child(userKey).update(
        {'firstName': firstName, 'lastName': lastName, 'mobile': mobileNumber});

    User? user = _auth.currentUser;
    user!.updateDisplayName(firstName + " " + lastName);
  }

  void hideButton() {
    setState(() {
      if (_buttonToggle) {
        _buttonToggle = !_buttonToggle;
      } else {
        _buttonToggle = true;
      }
    });
  }
}
