import 'package:firebase_database/firebase_database.dart';
import 'package:growth_app/navparent.dart';
import 'package:growth_app/parenthome.dart';
import 'package:growth_app/profilesetup.dart';
import 'package:growth_app/resetpassword.dart';
import 'package:growth_app/userprofile.dart';
import 'package:growth_app/workerselfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growth_app/nav.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // text field state
  bool checkboxValue = false;
  String email = '';
  String password = '';

  // Email Regex Expression
  RegExp emailRegExp = new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _formKey = GlobalKey<FormState>();
  final _userDbRef = FirebaseDatabase.instance.reference().child("user");

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
                    initialValue: email,
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
                      else if (!emailRegExp.hasMatch(val)){
                        return 'Enter a valid email address';
                      }
                      else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ))),
              SizedBox(height: 20.0),
              Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0),
                  child: (TextFormField(
                    initialValue: password,
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
                      setState(() => password = val);
                    },
                  ))),
              SizedBox(height: 20.0),
              Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0),
                  child: (CheckboxListTile(
                    title: Text("Keep me signed in?"),
                    value: this.checkboxValue,
                    onChanged: (value) {
                      setState(() {
                        this.checkboxValue = value as bool;
                      });
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
                                  authenticate(email, password, checkboxValue);
                                  print('pressed log in');
                                }
                              },
                            )))
                  ]),
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
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => ResetPasswordPage()));
                },
              )
            ]),
          ),
        ));
  }

  void authenticate(email, password, checkboxValue) async {
    try {
      UserCredential userAuth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);

      print(email);
      if (checkboxValue == true) {
        prefs.setBool('rmbMe', true);
        prefs.setString('password', password);
        if (email == "darrellerjr@gmail.com") {
          Navigator.pushReplacement(
              context, new MaterialPageRoute(builder: (context) => WorkerSelFamily()));
        } else {
          userVerification();
        }
      }
      else{
        if (email == "darrellerjr@gmail.com") {
          Navigator.pushReplacement(
              context, new MaterialPageRoute(builder: (context) => WorkerSelFamily()));
        } else {
          userVerification();
        }
      }
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

  void userVerification() {
    Query _userQuery = _userDbRef
        .orderByChild("email")
        .equalTo(email);

    _userQuery.once().then((DataSnapshot snapShot) async {
      print(snapShot.value);
      // User profile exist in DB => to home page
      if(snapShot.value != null) {
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('Session',email);

        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => NavParent()));
      } else {
        // User profile does not exist in DB => to home page
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('Session',email);

        Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (context) => ProfileSetUpPage()
        ));
      }
    });
  }
}
