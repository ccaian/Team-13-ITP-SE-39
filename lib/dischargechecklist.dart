import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DischargeCheckListPage extends StatefulWidget {
  @override
  _DischargeCheckListPageState createState() => _DischargeCheckListPageState();
}

class _DischargeCheckListPageState extends State<DischargeCheckListPage> {
  // text field state

  // Map<String, bool> routineCareList = {
  //
  // }
  //
  // Map<String, bool> feedingList = {
  // }
  //
  // Map<String, bool> caregiverList = {
  //
  // }
  // Map<String, bool> equipmentList = {
  //
  // }
  Map<String, bool> List = {
    's' : false,
    'f' : false,
    'g' : false,
    'h' : false,
    'j' : false,
    'a' : false,
    'd' : false,
    'c' : false,
    'v' : false,
    'w' : false,
    'q' : false,
    'e' : false,
    'r' : false,
    't' : false,
    'y' : false,
    'u' : false,
    'i' : false,
    'o' : false
  };
  
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: <Widget>[
            Expanded(
            child : ListView(
              children: List.keys.map((String key) {
                return new CheckboxListTile(
                  title: new Text(key),
                  value: List[key],
                  activeColor: Colors.deepPurple[400],
                  checkColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      List[key] = value as bool;
                    });
                  },
                );
              }).toList(),
            ),),
            new Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(80.0, 0, 80.0, 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          minimumSize: Size(50, 50),
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
                          List.forEach((key, value) {
                            print(key + " - " + value.toString());
                          });
                        },
                      )))
            ]),
          ]),
        );
  }
}
