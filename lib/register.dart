import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growth_app/login.dart';
import 'package:growth_app/nav.dart';



class RegisterPage extends StatefulWidget{

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // text field state
  String email ='';
  String password = '';
  String cfmPassword = '';

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
    return new Scaffold(
        body: Container(
        padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
                FittedBox(
                  child: new Image.asset('assets/loginsplash.png', width: 400, height: 380,),
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0,0.0,40.0,20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25),
                          ),
                        ),
                        labelText: 'Username',
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter a username' : null,
                      onChanged: (val) {
                        setState(() => email = val);
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
                        labelText: 'Password',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter password';
                        }
                        else if (val.length < 8){
                          return 'Enter a password with at least 8 characters';
                        }
                        else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() => password = val);
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
                        labelText: 'Confirm Password',
                      ),
                      onChanged: (val) {
                        setState(() => cfmPassword = val);
                      },
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
                              "Register",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                print('pressed register');
                                print(password);
                                print(cfmPassword);
                                if(password == cfmPassword) {
                                  print('swee');
                                  writeData(email, password);
                                }
                                else {
                                  Fluttertoast.showToast(
                                      msg: "Passwords does not match",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
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

  void writeData(email, password) async{
    try {
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => LoginPage()
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: "The password provided is too weak",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
