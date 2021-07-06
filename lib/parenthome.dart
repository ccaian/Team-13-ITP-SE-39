import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/dischargechecklist.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/parentselchild.dart';
import 'package:growth_app/workerselfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ParentHome extends StatefulWidget {
  @override
  _ParentHomeState createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  String? userName = "";
  String?  temp = "";
  String?  temp2 = "";
  String babyName = "";
  @override
  void initState(){
    loadPagePref();
    super.initState();
  }
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
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
                  "Welcome!\n"+ userName!,
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
                child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.07,
                          left: MediaQuery.of(context).size.width * 0.05,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              color: Color(0xff4C52A8),

                              borderRadius: const BorderRadius.all(
                                const Radius.circular(25),
                              ),
                            ),
                          )
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.width * 0.13,
                        left: MediaQuery.of(context).size.width * 0.11,

                        child: buildText(context),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.28,
                          left: MediaQuery.of(context).size.width * 0.11,

                          child: Text(
                              "Enter information here",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              )
                          )
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.45,
                          left: MediaQuery.of(context).size.width * 0.10,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              minimumSize: Size(200,50),
                              shape: shape,
                            ),
                            child: new Text(
                              "Change Baby",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),

                            ),
                            onPressed: () {
                              _navigateAndDisplaySelection(context);
                            },
                          )
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.70,
                          left: MediaQuery.of(context).size.width * 0.06,
                          child: Column(
                          children: [
                            Row( mainAxisAlignment: MainAxisAlignment.center,
                              children: [Container(
                                child: Text(
                                  "Discharge CheckList",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                                padding: EdgeInsets.all(20.0),
                                width: 175,
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)

                                ),

                              )
                              ],
                            )

                          ]

                      )),
                      Positioned(
                          top: MediaQuery.of(context).size.width * 1.00,
                          left: MediaQuery.of(context).size.width * 0.09,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              minimumSize: Size(100,25),
                              shape: shape,
                            ),
                            child: new Text(
                              "Go to Form",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),

                            ),
                            onPressed: () {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => DischargeCheckListPage()));
                            },
                          )
                      ),
                    ]

                )
            ),
          )
        ],
      ),
    );
  }

  Widget buildText(BuildContext context) => Text(
      "Currently Managing\n" + babyName,
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      )
  );

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    Navigator.push(context, new MaterialPageRoute(
        builder: (context) => ParentSelChild()
    ));
  }

  Future loadPagePref() async{
    List newList = [];
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    temp = sharedPreferences.getString('Session');
    temp2 = sharedPreferences.getString('ChildName');
    FirebaseDatabase.instance
        .reference()
        .child("user")
        .orderByChild("email")
        .equalTo(temp)
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      List tempList = childMap.values.toList();
      childMap.forEach((key, value) {
        newList.add(value['firstName'].toString());
      });
      setState(() {
        userName = newList[0].toString();
        babyName = temp2!;
      });
    });
  }
}
