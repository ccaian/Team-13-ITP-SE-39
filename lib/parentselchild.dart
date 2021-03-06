import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';




class ParentSelChild extends StatefulWidget {
  @override
  _ParentSelChildState createState() => _ParentSelChildState();
}

class _ParentSelChildState extends State<ParentSelChild> {
  List listOfChildren = [];
  String name = '';
  String username ='';
  List keys = [];
  List growthKey = [];
  Map keyMap = Map<String, String>();

  final _selectChild = FirebaseFirestore.instance.collection('child');

  @override
  void initState(){
    getPref();
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      return false;
    },
    child: Material(
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
    ));


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
                        //remove baby from generated list
                        _deleteDialog(context, items,listOfChildren[items]['nric']);

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

  void deleteChild(int index, String nric) async {
    _selectChild.doc(keys[index]).delete();
    for(var i =0; i < growthKey.length; i++){
      FirebaseFirestore.instance.collection('growth').doc(nric).collection('records').doc(growthKey[i]).delete();
    }

    FirebaseFirestore.instance.collection('growth').doc(nric).collection('records').doc().delete();

    keys.removeAt(index);
    keys.join(', ');


  }

  getGrowthId(int index, String nric) async{
    var tempKey;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('growth').doc(nric).collection('records').get();

    tempKey = querySnapshot.docs.map((doc) => doc.id).toList();

    setState(() {
      growthKey = tempKey;
    });
    deleteChild(index, nric);
  }

  Future<void> _getChildList() async {
    var tempKey;
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _selectChild.where('parent', isEqualTo: username).get();

    // Get data from docs and convert map to List
    listOfChildren = querySnapshot.docs.map((doc) => doc.data()).toList();
    tempKey = querySnapshot.docs.map((doc) => doc.id).toList();

    setState(() {
      listOfChildren = listOfChildren;
      keys = tempKey;
    });
  }

  //dialog box when deleting a baby
  void _deleteDialog(BuildContext context, int index, String nric) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Delete Child'),
              content: Text('Are you sure you want to delete?'),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: secondaryTheme,
                    ),
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: mainTheme,
                    ),
                    child: Text('Ok'),
                    onPressed: () {
                      getGrowthId(index,listOfChildren[index]['nric']);
                      setState(() {
                        listOfChildren.removeAt(index);
                        listOfChildren.join(', ');
                        Navigator.pop(context);
                      });
                    }),
              ]);
        });
  }
}

