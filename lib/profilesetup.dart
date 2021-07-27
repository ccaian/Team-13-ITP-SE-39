import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSetUpPage extends StatefulWidget {
  @override
  _ProfileSetUpPageState createState() => _ProfileSetUpPageState();
}

/// Profile Set Up Page state is for those first time login user to set up their profile account
class _ProfileSetUpPageState extends State<ProfileSetUpPage> {
  /// text field variables
  var _firstName, _lastName, _mobileNumber;
  final _userReference = FirebaseFirestore.instance.collection('user');
  final _formKey = GlobalKey<FormState>();

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
                  child: Text("Profile Set up",
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
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                80.0, 20.0, 80.0, 0.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: secondaryTheme,
                                                minimumSize: Size(50, 50),
                                                shape: shape,
                                              ),
                                              child: new Text(
                                                "Save",
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
                                                  writeData();
                                                }
                                              },
                                            )))
                                  ]),
                            ]),
                      )))
            ])));
  }

  /// Function for create a user document in user collection
  void writeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userReference.add({
      'firstName': _firstName,
      'lastName': _lastName,
      'email': prefs.getString('email'),
      'mobile': _mobileNumber,
      'admin': false
    });

    prefs.setBool('admin', false);

    Navigator.of(context).pushNamed('/selectChild');
  }
}
