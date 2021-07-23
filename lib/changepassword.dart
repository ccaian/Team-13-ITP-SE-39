import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChangePasswordPage extends StatefulWidget{

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

/// Change Password Page State for changing of password where required.
class _ChangePasswordPageState extends State<ChangePasswordPage> {


  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    /// text field variables
    var _oldPassword, _newPassword;

    /// Password Regex Expression
    RegExp passwordRegExp = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    final _formKey = GlobalKey<FormState>();
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: new SingleChildScrollView(
          //padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                FittedBox(
                  child: new Image.asset('assets/loginsplash.png', width: 400, height: 380,),
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0,0.0,40.0,20.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25),
                        ),
                      ),
                      labelText: 'Old Password',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter Old Password';
                      }
                      else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() => _oldPassword = val.trim());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0,0.0,40.0,20.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25),
                        ),
                      ),
                      labelText: 'New Password',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter New password';
                      }
                      else if (!passwordRegExp.hasMatch(val)){
                        return 'Enter a password with at least 8 characters, Lower case, Upper case, alphanumeric and special case letter';
                      }
                      else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() => _newPassword = val.trim());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0,0.0,40.0,5.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25),
                        ),
                      ),
                      labelText: 'Confirm New Password',
                    ),
                    validator: (val) =>
                    val != _newPassword ? 'Password does not match' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(52.0,0.0,40.0,5.0),
                  child: Text(
                    "Password Requirement:"
                        "\n* At least 8 characters, "
                        "\n* At least 1 Lower case, "
                        "\n* At least 1 Upper case, "
                        "\n* At least 1 Alphanumeric number "
                        "\n* At least 1 Special case letter",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0
                    ),
                  ),
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Padding(
                          padding: const EdgeInsets.fromLTRB(80.0,20.0,80.0,0.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              minimumSize: Size(50,50),
                              shape: shape,
                            ),
                            child: new Text(
                              "Change Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                _reauthenticateUser(_oldPassword, _newPassword);
                              }
                            },
                          )
                      ))
                    ]
                ),
              ]
              ),
            )
        ));
  }

  /// Funtion to verify the current password input matches the password stored in Firebase Auth
  ///
  /// Accepts [oldPassword] : the current password stored in firebase,
  /// [newPassword] : the password to change to
  void _reauthenticateUser(String oldPassword, String newPassword) async {
    /// Retrieve user email stored in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString('email').toString();

    /// verify if old password is valid
    AuthCredential credential = EmailAuthProvider.credential(email: userEmail, password: oldPassword);

    await auth.currentUser!.reauthenticateWithCredential(credential).then((_){
      _changePassword(newPassword);
    }).catchError((error){
      Fluttertoast.showToast(
          msg: "Old Password is Invalid",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }

  /// Funtion to change the password stored in Firebase Auth
  ///
  /// Accepts [password] : the password to change to
  void _changePassword(String password) {
    /// Create an instance of the current user.
    User? user = auth.currentUser;
    /// Pass in the password to updatePassword.
    user!.updatePassword(password).then((_){
      Fluttertoast.showToast(
          msg: "Successfully changed password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pop(context);
    }).catchError((error){
      Fluttertoast.showToast(
          msg: "Password can't be changed" + error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }
}