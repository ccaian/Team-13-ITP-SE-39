import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/register.dart';
import 'package:growth_app/workerhome.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text field state
  String email = '';
  String password = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    return new Scaffold(
        body: Container(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
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
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              fillColor: Colors.grey,
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(25),
                ),
              ),
              labelText: 'Username',
            ),
            validator: (val) => val!.isEmpty ? 'Enter your username' : null,
            onChanged: (val) {
              setState(() => email = val);
            },
          ),
          SizedBox(height: 20.0),
          TextFormField(
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
            validator: (val) => val!.isEmpty ? 'Enter your password' : null,
            onChanged: (val) {
              setState(() => password = val);
            },
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
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
              if(_formKey.currentState!.validate()) {
                authenticate(email, password);
                print('pressed log in');
              }
            },
          ),
          TextButton(
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
            },
          )
        ]),
      ),
    ));
  }

  void authenticate(email, password) async {
    try {
      UserCredential userAuth = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => Nav()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "No user found for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Wrong password provided for that user",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }
}
