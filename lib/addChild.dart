import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


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
  var gestationPickedDate;

  final _addchildKey = GlobalKey<FormState>();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  var _childRef = FirebaseDatabase.instance.reference().child('child');
  TextEditingController _nameControl = TextEditingController();
  TextEditingController _nricControl = TextEditingController();
  TextEditingController _gdateControl = TextEditingController();
  SingingCharacter? _character = SingingCharacter.Male;

  final _addChild = FirebaseFirestore.instance.collection('child');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: mainTheme,
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
                        padding: const EdgeInsets.fromLTRB(20.0,50.0,20.0,20.0),
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
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter Name';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,0.0),
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
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter NRIC';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,0.0),
                        child: TextField(
                          controller: _gdateControl, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Enter Gestation Date" //label text of field
                          ),
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context, initialDate: DateTime.now(),
                                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );

                            if(pickedDate != null ){
                              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                _gdateControl.text = formattedDate; //set output date to TextField value.
                                gestationPickedDate = pickedDate;
                              });
                            }else{
                              print("Date is not selected");
                            }
                          },
                        )
                      ),
                      Padding(padding: new EdgeInsets.only(left: 10)),
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(padding: new EdgeInsets.all(10)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(padding: new EdgeInsets.all(15)),
                              Text("Gender:" ,textAlign: TextAlign.right, style: TextStyle(fontSize: 18),),
                            ]
                          ),
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
                                    primary: mainTheme,
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
                                    if(!_addchildKey.currentState!.validate()){
                                      return;
                                    }
                                      print('Submit');
                                      getPrefAddChild(name, nric);
                                      Navigator.of(context).pushNamed("/selectChild");
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

  void _addChildData() {
    _addChild.add({
      'name': _nameControl.text,
      'nric': _nricControl.text,
      'gestationDate': gestationPickedDate,
      'parent': parentEmail,
      'gender': gender
    });
  }

  Future getPrefAddChild(name, nric) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    temp = sharedPreferences.getString('email')!;
    setState(() {
      parentEmail = temp;
    });
    _addChildData();
  }

}

