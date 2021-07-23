import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growth_app/theme/colors.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

/// Register Page State for registration of new user accounts
class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    /// text field state
    var email, password, cfmPassword = '';

    /// Email and Password Regex Expression
    RegExp emailRegExp = new RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    RegExp passwordRegExp = new RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    final _formKey = GlobalKey<FormState>();
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    return new Scaffold(
        body: new SingleChildScrollView(
            //padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
            child: Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
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
              setState(() => email = val.trim());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
          child: TextFormField(
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
            validator: (val) {
              if (val!.isEmpty) {
                return 'Enter password';
              } else if (!passwordRegExp.hasMatch(val)) {
                return 'Enter a password with at least 8 characters, Lower case, Upper case, alphanumeric and special case letter';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() => password = val.trim());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 5.0),
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              fillColor: Colors.grey,
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(25),
                ),
              ),
              labelText: 'Confirm Password',
            ),
            validator: (val) =>
                val != password ? 'Password does not match' : null,
            onChanged: (val) {
              setState(() => cfmPassword = val.trim());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(52.0, 0.0, 40.0, 5.0),
          child: Text(
            "Password Requirement:"
            "\n* At least 8 characters, "
            "\n* At least 1 Lower case, "
            "\n* At least 1 Upper case, "
            "\n* At least 1 Alphanumeric number "
            "\n* At least 1 Special case letter",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
          ),
        ),
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(80.0, 10.0, 80.0, 0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: secondaryTheme,
                      minimumSize: Size(50, 50),
                      shape: shape,
                    ),
                    child: new Text(
                      "Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (password == cfmPassword) {
                          writeData(email, password);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Passwords does not match",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: secondaryTheme,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                  ))),
        ]),
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          TextButton(
            child: new Text(
              "Have an Account? Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey[700],
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("/login");
            },
          ),
        ]),
      ]),
    )));
  }

  /// Function for creating user account in Firebase Auth.
  ///
  /// Function will use [email] and [password] params to create a Firebase Auth
  /// user account.
  void writeData(email, password) async {
    try {
      /// create user account in Firebase Auth
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      /// get the user account that was created and send a email verification
      User user = FirebaseAuth.instance.currentUser!;
      user.sendEmailVerification();

      /// run the dialog to notify user to verify their email
      verificationDialog(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: "The password provided is too weak",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: secondaryTheme,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: secondaryTheme,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }
}

void verificationDialog(BuildContext context) {
  var alert = AlertDialog(
      title: Text(
        'An email has been sent to your email for verification. Please verify before logging in.',
        style: TextStyle(fontSize: 12),
      ),
      actions: <Widget>[
        ElevatedButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pushNamed("/login");
            }),
      ]);

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
