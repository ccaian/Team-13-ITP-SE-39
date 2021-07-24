import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

///  Login Page State for authenticating and verifying user account.
class _LoginPageState extends State<LoginPage> {
  /// Firestore reference for User collection
  final _userReference = FirebaseFirestore.instance.collection('user');

  /// text field variables
  var _email, _password;

  /// Email Regex Expression
  RegExp emailRegExp = new RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                      } else if (!emailRegExp.hasMatch(val)) {
                        return 'Enter a valid email address';
                      } else {
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
              new Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(80.0, 0, 80.0, 0.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: secondaryTheme,
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
                  Navigator.of(context).pushNamed("/register");
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),
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
                    Navigator.of(context).pushNamed("/resetPassword");
                  },
                ),
              )
            ]),
          ),
        ));
  }

  /// Authenticate Function for authenticating user.
  ///
  /// Function will use [email] and [password] params to execute Firebase Auth Function to
  /// authenticate user account.
  void authenticate(email, password) async {
    try {
      /// Authenticate user if error is thrown, Toast will run based on error
      UserCredential userAuth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);

      userVerification(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "No user found for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: secondaryTheme,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Wrong password provided for that user",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: secondaryTheme,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  /// Verification Function for verifying if user has verify their email.
  ///
  /// Function will use [email] params to check Firebase current user
  /// if email has been verified.
  void userVerification(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentUser = FirebaseAuth.instance.currentUser;

    /// check if current user has verify their email
    if (currentUser!.emailVerified) {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _userReference.where('email', isEqualTo: email).get();
      List user = snapshot.docs;

      /// User profile exist in DB => to home page
      if (user.isNotEmpty) {
        user.forEach((element) {
          prefs.setBool('admin', element['admin']);
          prefs.setString('firebaseKey', element.id);
          print(element['admin']);
          print(element.id);

          /// check if the value 'adminPin' exist
          if (element['adminPin'] != null) {
            prefs.setString('adminPin', element['adminPin']);
            print(element['adminPin']);
          }
        });

        /// check if user is admin or not => to redirect user according to their user type
        if (prefs.getBool('admin') == true) {
          /// user is a healthcare worker
          Navigator.of(context).pushReplacementNamed('/selectFamily');
        } else {
          /// user is a parent and not first login
          Navigator.of(context).pushReplacementNamed('/selectChild');
        }
      } else {
        /// user is a parent and this is the first login
        Navigator.of(context).pushReplacementNamed('/profileSetup');
      }
    } else {
      /// clear user if account not verified
      await prefs.clear();
      await FirebaseAuth.instance.signOut();

      Fluttertoast.showToast(
          msg: "Account is not verified. Please verify and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: secondaryTheme,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
