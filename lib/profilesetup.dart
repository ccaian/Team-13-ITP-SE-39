import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growth_app/login.dart';
import 'package:growth_app/nav.dart';



class ProfileSetUpPage extends StatefulWidget{

  @override
  _ProfileSetUpPageState createState() => _ProfileSetUpPageState();
}

class _ProfileSetUpPageState extends State<ProfileSetUpPage> {

  // text field state
  String firstName ='';
  String lastName = '';
  String email = '';
  int mobileNumber = 0;

  FirebaseDatabase database = new FirebaseDatabase();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
    return new Scaffold(
        body: new SingleChildScrollView(
            //padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
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
                      labelText: 'First Name',
                    ),
                    validator: (val) => val!.isEmpty ? 'Enter First Name' : null,
                    onChanged: (val) {
                      setState(() => firstName = val);
                    },
                  ),
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
                      labelText: 'Last Name',
                    ),
                    validator: (val) => val!.isEmpty ? 'Enter Last Name' : null,
                    onChanged: (val) {
                      setState(() => lastName = val);
                    },
                  ),
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
                      labelText: 'Mobile Number',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter Mobile Number';
                      }
                      else if (val.length != 8){
                        return 'Please check if Mobile Number is correct';
                      }
                      else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() => mobileNumber = val as int);
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
                              "Save",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                writeData();
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

  void writeData() async{
    DatabaseReference _userRef = database.reference().child('growth');
    _userRef.push().set({
      "name": "" + firstName,
      "age": "" + lastName,
      "email": email,
      "mobile": mobileNumber
    });

    //redirect to parent home
  }
}