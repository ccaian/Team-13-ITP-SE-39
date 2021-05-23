import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/workerhome.dart';



class LoginPage extends StatefulWidget{

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
    return new Scaffold(
        body: SingleChildScrollView(
          child: Column(
              children: <Widget>[

                FittedBox(
                  child: new Image.asset('assets/loginsplash.png', width: 400, height: 380,),
                  fit: BoxFit.fill,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(40.0,0.0,40.0,20.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(25),
                            ),
                          ),
                          fillColor: Colors.red,
                          labelText: 'Username',
                      ),)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(40.0,0.0,40.0,20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25),
                          ),
                        ),
                          labelText: 'Password',
                      ),)),
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
                              "Log In",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),

                            ),
                            onPressed: () {

                              print('pressed log in');
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => Nav()
                              ));
                            },
                          )
                      ))

                    ]
                ), new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Padding(
                          padding: const EdgeInsets.fromLTRB(80.0,0.0,80.0,0.0),
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
                            onPressed: () => print('register account'),
                          )
                      ))

                    ]
                ),
                
              ]
          ),
        )
    );
  }
}
