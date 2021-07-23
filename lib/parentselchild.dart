import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addChild.dart';



class ParentSelChild extends StatefulWidget {
  @override
  _ParentSelChildState createState() => _ParentSelChildState();
}

class _ParentSelChildState extends State<ParentSelChild> {
  List<String> litems = [];
  List babyData = [];
  String name = '';
  String temp ='';
  String username ='';
  Map keyMap = Map<String, String>();
  DatabaseReference reference = FirebaseDatabase.instance.reference().child('child');
  DatabaseReference growth = FirebaseDatabase.instance.reference().child('growth');
  DatabaseReference checklist = FirebaseDatabase.instance.reference().child('checklist');

  @override
  void initState(){
    getPref();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: mainTheme,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 80,
                left: 30,
                child: Text(
                    "Select Child",
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
                child: Scaffold(
                    body: new ListView.builder
                      (padding: const EdgeInsets.all(8),
                        itemCount: litems.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return new GestureDetector( //You need to make my child interactive
                            child: new Column(
                              children: <Widget>[
                                //new Image.network(video[index]),
                                new Padding(padding: new EdgeInsets.all(16.0)),
                                buildText(index),


                              ],
                            ),
                          );
                        }
                    )

                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: mainTheme,
                onPressed: () async {
                  Navigator.of(context).pushNamed("/addChild");
                },
              ),
            ),
          ],
        ),
      ),
    );


  }

  Widget buildText(int items) {
    String babyTitle ='';
    babyTitle = getBabyName(litems[items]);
    return Card(
      child:
          ListTile(
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        //   _onDeleteItemPressed(index);
                        deleteChild(litems[items]);
                        setState(() {
                          litems.removeAt(items);
                          litems.join(', ');
                        });
                      }
                  )
                ]
            ),
            title: Text(
              babyTitle,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString('ChildName',babyTitle);
              sharedPreferences.setString('ChildNRIC',litems[items]);

              Navigator.of(context).pushNamed("/homePage");
            },
          )
    );
  }

  Widget addButton(BuildContext context){
    return  Column(
        children: <Widget>[ TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) => AddChild()
            ));
          },
          child: const Text('+'),
        ),
        ]);}

  makeList(){
    List<String> newList = [];
    FirebaseDatabase.instance
        .reference()
        .child("child")
        .orderByChild("parent")
        .equalTo(username)
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      List temp = childMap.values.toList();
      childMap.forEach((key, value) {
        newList.add(value['nric'].toString());
      });
      setState(() {
        litems = newList;
      });
    });
    getChildList();
  }

  getChildList(){
    List tempList = [];
    FirebaseDatabase.instance
        .reference()
        .child("child")
        .orderByChild("parent")
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      childMap.forEach((key, value) {
        tempList.add(value);
      });
      setState(() {
        babyData = tempList;
      });
    });
    makeKeyList();
  }

  Future getPref() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    temp = sharedPreferences.getString('email')!;
    setState(() {
      username = temp;
    });

    makeList();
  }

  makeKeyList(){
    FirebaseDatabase.instance
        .reference()
        .child("child")
        .orderByChild("nric")
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      childMap.forEach((key, value) {
          keyMap[value['nric'].toString()] = key;

      });
      setState(() {
        keyMap = keyMap;
      });
    });
  }

  String getBabyName( String babyNRIC) {
    String babyName = '';
    for(var i = 0; i < babyData.length; i++){
      if(babyNRIC == babyData[i]["nric"].toString()){
        babyName = babyData[i]["name"].toString();
      }
    }
    if(babyName == ''){
      babyName = 'No Children';
    }
    return babyName;
  }

  void deleteChild(String nric) async {
    var tempKey;
    keyMap.forEach((key, value) {
      if(nric == key){
        tempKey =value;
      }
    });
    await reference.child(tempKey).remove();
    //await growth.child(getGrowthKey(nric)).remove();
  }

  String getGrowthKey(String nric){
    String returnKey ='';
    FirebaseDatabase.instance
        .reference()
        .child("growth")
        .orderByChild("nric")
        .equalTo(nric)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> childMap = snapshot.value;
      childMap.forEach((key, value) {
        returnKey = key;
      });
    });
    return returnKey;
  }

  String getCheckListKey(String nric){
    String returnKey ='';
    FirebaseDatabase.instance
        .reference()
        .child("checklist")
        .orderByChild("email")
        .equalTo(nric)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> childMap = snapshot.value;
      childMap.forEach((key, value) {
        returnKey = key;
      });
    });
    return returnKey;
  }
}

