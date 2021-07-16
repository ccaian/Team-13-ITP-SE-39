import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growth_app/growthpage.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/parentselchild.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddChild extends StatefulWidget {
  @override
  _AddChildPageState createState() => _AddChildPageState();
}
enum SingingCharacter { Male, Female }
class _AddChildPageState extends State<AddChild> {

  String name = '';
  String nric = '';
  String temp = '';
  String parentEmail = '';
  String gender = 'male';

  final _addchildKey = GlobalKey<FormState>();

  var _childRef = FirebaseDatabase.instance.reference().child('child');
  TextEditingController _nameControl = TextEditingController();
  TextEditingController _nricControl = TextEditingController();
  SingingCharacter? _character = SingingCharacter.Male;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: Color(0xff4C52A8),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 80,
                left: 30,
                child: Text(
                    "Add Child",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                )
            ),
            Positioned(
              top: 40,
              right: -10,
              child: new Image.asset('assets/healthcare.png', width: 140.0),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(

                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0)),
                  ),
                  child: Form(
                    key: _addchildKey,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40.0,50.0,40.0,20.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(25),
                              ),
                            ),
                            labelText: 'Name',
                          ),
                          controller: _nameControl,
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
                            labelText: 'NRIC',
                          ),
                          controller: _nricControl,
                        ),
                      ),
                      new Column(
                        children: <Widget>[
                          ListTile(
                            title: const Text('Male'),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.Male,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                  gender = 'male';
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Female'),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.Female,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                  gender = 'female';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(child: Padding(
                                padding: const EdgeInsets.fromLTRB(80.0,20.0,80.0,0.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple,
                                    minimumSize: Size(50,50),
                                    //shape: shape,
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
                                      print('Submit');
                                      getPrefAddChild(name, nric);
                                      Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) => ParentSelChild()
                                      ));
                                  },
                                )
                            ))

                          ]
                      ),
                    ]
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  void addChildData(name, nric) {
    _childRef.push().set({
      'name': _nameControl.text,
      'nric': _nricControl.text,
      'parent': parentEmail,
      'gender' : gender
    });
  }

  Future getPrefAddChild(name, nric) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    temp = sharedPreferences.getString('Session')!;
    setState(() {
      parentEmail = temp;
    });
    print("In getPref "+parentEmail);
    addChildData(name, nric);
  }

}

