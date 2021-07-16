import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:growth_app/register.dart';
import 'package:growth_app/resetpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // text field state
  var _email, _password;

  // Email Regex Expression
  RegExp emailRegExp = new RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _formKey = GlobalKey<FormState>();
  final _userDbRef = FirebaseDatabase.instance.reference().child("user");
  var currentUser;

  @override
  Widget build(BuildContext context) {
    final shape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    return new Scaffold(
        resizeToAvoidBottomInset: false,
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
              SizedBox(height: 20.0),
              Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0),
                  child: (TextFormField(
                    initialValue: _email,
                    decoration: InputDecoration(
                      fillColor: Colors.grey,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25),
                        ),
                      ),
                      labelText: 'Email Address',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter an email address';
                      }
                      else if (!emailRegExp.hasMatch(val)) {
                        return 'Enter a valid email address';
                      }
                      else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() => _email = val.trim());
                    },
                  ))),
              SizedBox(height: 20.0),
              Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0),
                  child: (TextFormField(
                    initialValue: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25),
                        ),
                      ),
                      labelText: 'Password',
                    ),
                    validator: (val) =>
                    val!.isEmpty ? 'Enter your password' : null,
                    onChanged: (val) {
                      setState(() => _password = val.trim());
                    },
                  ))),
              SizedBox(height: 20.0),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                80.0, 0, 80.0, 0.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                minimumSize: Size(50, 50),
                                shape: shape,
                              ),
                              child: new Text(
                                "Log In",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  authenticate(_email, _password);
                                  print('pressed log in');
                                }
                              },
                            )))
                  ]),
              TextButton(
                child: new Text(
                  "Register an Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[700],
                  ),
                ),
                onPressed: () {
                  print('Forgot Password');
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    80.0, 0.0, 80.0, 0.0),
                child: TextButton(
                  child: new Text(
                    "Forgot Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[700],
                    ),
                  ),
                  onPressed: () {
                    print('Forgot Password');
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ResetPasswordPage()));
                  },
                ),
              )
            ]),
          ),
        ));
  }

  void authenticate(email, password) async {
    try {
      UserCredential userAuth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);

      currentUser = FirebaseAuth.instance.currentUser;
      print(currentUser);

      userVerification(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "No user found for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Wrong password provided for that user",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  void userVerification(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (currentUser.emailVerified) {
      Query _userQuery = _userDbRef
          .orderByChild("email")
          .equalTo(email);

      prefs.setString('Session', email);

      _userQuery.once().then((DataSnapshot snapShot) async {
        print(snapShot.value);

        // User profile exist in DB => to home page
        if (snapShot.value != null) {
          Map<dynamic, dynamic> values = snapShot.value;
          values.forEach((key, values) {

            prefs.setBool('admin', values['admin']);
            prefs.setString('firebaseKey', key);

            if (values['adminPin'] != null) {
              prefs.setString('adminPin', values['adminPin']);
            }
          });

          if(prefs.getBool('admin') == true) {
            // user is a healthcare worker
            Navigator.of(context).pushNamed('/adminHome');
          } else {
            // user is a parent and not first login
            Navigator.of(context).pushNamed('/parentHome');
          }
        } else {
          // user is a parent and this is the first login
          Navigator.of(context).pushNamed('/profileSetup');
        }
      });
    }
    else {
      // clear user if account not verified
      await prefs.clear();
      await FirebaseAuth.instance.signOut();

      Fluttertoast.showToast(
          msg: "Account is not verified. Please verify and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
