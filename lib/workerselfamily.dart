import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/workerhome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerSelFamily extends StatefulWidget{

  @override
  _WorkerSelFamilyState createState() => _WorkerSelFamilyState();
}

class _WorkerSelFamilyState extends State<WorkerSelFamily> {
  List<String> litems = [];

  @override
  void initState(){
    makeList();
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
              child: Text("Select Family",
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ))),
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
                  body: new ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: litems.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new GestureDetector(
                          //You need to make my child interactive
                          onTap: () async{
                            final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                            sharedPreferences.setString('Fam',litems[index]);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => Nav())).then((value) => setState( () {} ));;
                          },

                          child: new Column(
                            children: <Widget>[
                              //new Image.network(video[index]),
                              new Padding(padding: new EdgeInsets.all(16.0)),
                              buildText(index),
                            ],
                          ),
                        );
                        //new Text(litems[index]);
                      })),
            ),
          )
        ],
      ),
    );
  }

  Widget buildText(int items) {
    return Card(
      child: ExpansionTile(
        title: Text(
          litems[items] + " Family",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        children: <Widget>[
          ListTile(
            title: Text(
              'Child 1',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }

  makeList(){
    List<String> newList = [];
    FirebaseDatabase.instance
        .reference()
        .child("user")
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      List temp = childMap.values.toList();
      childMap.forEach((key, value) {
        newList.add(value['firstName'].toString() + " " + value['lastName'].toString());
      });
      print(newList);
      setState(() {
        litems = newList;
      });
      print(litems);
    });
  }
}
