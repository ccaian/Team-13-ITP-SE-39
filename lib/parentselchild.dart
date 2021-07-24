import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  List listOfChildren = [];
  String name = '';
  String username ='';
  Map keyMap = Map<String, String>();

  final _selectChild = FirebaseFirestore.instance.collection('child');


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
                        itemCount: listOfChildren.length,
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
    //get baby name form baby nric
    babyTitle = listOfChildren[items]['name'];
    return Card(
      child:
          ListTile(
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                       /* //remove baby from generated list
                        deleteChild(listOfChildren[items]);
                        setState(() {
                          listOfChildren.removeAt(items);
                          listOfChildren.join(', ');
                        });*/
                      }
                  )
                ]
            ),
            title: Text(
              babyTitle,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              // save child details into shared preferences
              // ['ChildNRIC'] is nric of selected child
              // ['ChildName'] is name of selected child
              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString('ChildName',babyTitle);
              sharedPreferences.setString('ChildNRIC',listOfChildren[items]['nric']);

              Navigator.of(context).pushNamed("/homePage");
            },
          )
    );
  }

  Widget addButton(BuildContext context){
    //add child button
    return  Column(
        children: <Widget>[ TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            Navigator.of(context).pushNamed("/addChild");
          },
          child: const Text('+'),
        ),
        ]);}

  Future getPref() async {
    String temp ='';
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    temp = sharedPreferences.getString('email')!;
    setState(() {
      username = temp;
    });

    _getChildList();
    //makeList();
  }

  makeKeyList(){
    //save key linked with child nric into [keyMap]
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

  Future<void> _getChildList() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _selectChild.where('parent', isEqualTo: username).get();

    // Get data from docs and convert map to List
    listOfChildren = querySnapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      listOfChildren = listOfChildren;
    });
  }
}

