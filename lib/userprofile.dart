import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  _UserProfilePageState createState() => _UserProfilePageState();
}

/// User Profile Page state for users to view and update their personal details.
class _UserProfilePageState extends State<UserProfilePage> {
  /// Private Variables
  var _firstName, _lastName, _mobileNumber, _userKey;
  var _buttonToggle = true;
  var _editToggle = false;

  /// Firebase reference for user collection
  final _userReference = FirebaseFirestore.instance.collection('user');
  final _formKey = GlobalKey<FormState>();

  /// to ensure certain function is execute before page load for certain data
  @override
  void initState() {
    retrieveData().then((List value) {
      value.forEach((element) {
        setState(() {
          _userKey = element.id;
          _firstName = element['firstName'];
          _lastName = element['lastName'];
          _mobileNumber = element['mobile'];
        });
      });
    });
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
                  child: Text("User Profile",
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ))),
              Positioned(
                top: 40,
                right: -10,
                child: new Image.asset('assets/healthcare.png', width: 140.0),
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
                                  controller:
                                      TextEditingController(text: _firstName),
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
                                  validator: (val) =>
                                      val!.isEmpty ? 'Enter First Name' : null,
                                  onChanged: (val) {
                                    setState(() => _firstName = val);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    40.0, 0.0, 40.0, 20.0),
                                child: TextFormField(
                                  controller:
                                      TextEditingController(text: _lastName),
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
                                  validator: (val) =>
                                      val!.isEmpty ? 'Enter Last Name' : null,
                                  onChanged: (val) {
                                    setState(() => _lastName = val);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    40.0, 0.0, 40.0, 20.0),
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: _mobileNumber),
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
                                    setState(() => _mobileNumber = val);
                                  },
                                ),
                              ),
                              SizedBox(height: 0.0),
                              !_buttonToggle
                                  ? const SizedBox.shrink()
                                  : new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                          Expanded(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          80.0, 0.0, 80.0, 0.0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: mainTheme,
                                                      minimumSize: Size(50, 50),
                                                      shape: shape,
                                                    ),
                                                    child: new Text(
                                                      "Edit Details",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                                  : new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        80.0, 0.0, 80.0, 0.0),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: secondaryTheme,
                                                    minimumSize: Size(50, 50),
                                                    shape: shape,
                                                  ),
                                                  child: new Text(
                                                    "Cancel",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.normal,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                          Expanded(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          80.0,
                                                          10.0,
                                                          80.0,
                                                          0.0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: mainTheme,
                                                      minimumSize: Size(50, 50),
                                                      shape: shape,
                                                    ),
                                                    child: new Text(
                                                      "Update Details",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                      )))
            ])));
  }

  /// Function is for retrieving the user's personal details before page load.
  Future<List> retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _userReference.where('email', isEqualTo: email).get();
    List userList = snapshot.docs;
    return userList;
  }

  /// Function is for updating user's personal details.
  updateDetails() {
    _userReference.doc(_userKey).update({
      'firstName': _firstName,
      'lastName': _lastName,
      'mobile': _mobileNumber
    });

    User? user = FirebaseAuth.instance.currentUser;
    user!.updateDisplayName(_firstName + " " + _lastName);
  }

  /// Function is for toggling between the fields being editable or not.
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
