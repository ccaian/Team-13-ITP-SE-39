import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/navparent.dart';
import 'package:growth_app/workerhome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addChild.dart';



class ParentSelChild extends StatefulWidget {
  @override
  _ParentSelChildState createState() => _ParentSelChildState();
}

class _ParentSelChildState extends State<ParentSelChild> {
  List<String> litems = [];
  List<String> childNRICList = [];
  String name = '';
  String temp ='';
  String username ='';
  DatabaseReference reference = FirebaseDatabase.instance.reference().child('child');

  @override
  void initState(){
    getPref();
    print('post func');
    print(litems);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff4C52A8),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 80,
              left: 30,
              child: Text(
                  "Select Patient",
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
                          onTap: () async {
                            final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                            sharedPreferences.setString('ChildName',litems[index]);
                            sharedPreferences.setString('ChildNRIC',childNRICList[index]);
                            print('GET CHILD NRIC: ' + childNRICList[index]);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavParent())).then((value) => setState( () {} ));;
                          },

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
            top: 200,
            right: -10,
            child: addButton(context),
          )
        ],
      ),
    );


  }

  Widget buildText(int items) {
    print('at build text');
    return Card(
      child:
          ListTile(
            title: Text(
              litems[items],
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
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
    print("in makeList" + username);
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
        newList.add(value['name'].toString());
      });
      print(newList);
      setState(() {
        litems = newList;
      });
      print(litems);
    });
    getChildNRIC();
  }

  getChildNRIC(){
    List<String> tempList = [];
    FirebaseDatabase.instance
        .reference()
        .child("child")
        .orderByChild("parent")
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      List temp = childMap.values.toList();
      childMap.forEach((key, value) {
        tempList.add(value['nric'].toString());
      });
      print('child List:');
      print(tempList);
      setState(() {
        childNRICList = tempList;
      });
    });
  }

  Future getPref() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    temp = sharedPreferences.getString('Session')!;
    setState(() {
      username = temp;
    });
    print("In getPref "+username);

    makeList();
  }

}
