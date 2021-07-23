import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growth_app/theme/colors.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

/// Reset Password Page State for resetting password where required.
class _ResetPasswordPageState extends State<ResetPasswordPage> {
  /// text field state
  String _email = '';

  /// Email Regex Expression
  RegExp _emailRegExp = new RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: new SingleChildScrollView(
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
                  } else if (!_emailRegExp.hasMatch(val)) {
                    return 'Enter a valid email address';
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() => _email = val.trim());
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: secondaryTheme,
                          minimumSize: Size(50, 50),
                          shape: shape,
                        ),
                        child: Text(
                          "Reset Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (verifyEmail(_email)) {
                              resetPassword(_email);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Email does not exist.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: secondaryTheme,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                        },
                      )))
            ]),
          ]),
        )));
  }

  /// Function is for verifying if input email exists
  ///
  /// Function will use [email] variable and return true or false based on the verify result
  bool verifyEmail(email) {
    var verify = FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

    /// if [verify] is not null, account exist
    if (verify != null) {
      return true;
    }
    return false;
  }

  /// Function is for verifying if input email exists
  ///
  /// Function will send a reset password email to the [email]
  void resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    Navigator.of(context).pushReplacementNamed("/login");
  }
}
