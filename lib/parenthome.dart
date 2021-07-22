import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/dischargechecklist.dart';
import 'package:growth_app/main.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/parentselchild.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:growth_app/wellbeingsurvey.dart';
import 'package:growth_app/workerforum.dart';
import 'package:growth_app/workerselfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentHome extends StatefulWidget {
  @override
  _ParentHomeState createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  String? userName = "";
  String? temp = "";
  String? temp2 = "";
  String babyName = "";
  String? famName = "";
  String? childName = "";
  bool admin = false;
  final shape =
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));

  @override
  void initState() {
    loadPagePref();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      color: mainTheme,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 80,
              left: 30,
              child: welcomeText()
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
                child: Stack(children: <Widget>[
                  Positioned(
                      top: MediaQuery.of(context).size.width * 0.07,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          color: mainTheme,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25),
                          ),
                        ),
                      )),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.13,
                    left: MediaQuery.of(context).size.width * 0.11,
                    child: buildText(context),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.width * 0.28,
                      left: MediaQuery.of(context).size.width * 0.11,
                      child: adminManagingText()
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.width * 0.38,
                      left: MediaQuery.of(context).size.width * 0.10,
                      child: selectButton()
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.3,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child:SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        "/forum");
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.425,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 20.0, 0.0, 0.0),
                                        child: Text("Forum",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.grey[600],
                                            ))),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff2f2f2),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 20.0, 0.0, 0.0),
                                ),
                                InkWell(
                                  onTap: () {
                                    wellbeingRouting();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.425,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 20.0, 20.0, 20.0),
                                        child: Text("Wellbeing Survey",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.grey[600],
                                            ))),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff2f2f2),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 20.0, 0.0, 0.0),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        "/dischargeCheckList");
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.425,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 20.0, 0.0, 0.0),
                                        child: Text("Discharge Checklist",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.grey[600],
                                            ))),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff2f2f2),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 20.0, 0.0, 0.0),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        "/developmentDomain");
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.425,
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 20.0, 20.0, 20.0),
                                        child: Text("Development Domain",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.grey[600],
                                            ))),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff2f2f2),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                              ])
                        ],
                      ))),
                ])),
          )
        ],
      ),
    );
  }

  Widget buildText(BuildContext context) =>
      mainText();


  Future loadPagePref() async {
    List newList = [];
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    temp = sharedPreferences.getString('email');
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
        admin = sharedPreferences.getBool('admin')!;
        famName = sharedPreferences.getString('Fam');
        childName = sharedPreferences.getString('ChildName');
      });
    });
  }

  welcomeText(){
    if(admin == true){
      return new Text("Welcome!\n Admin" ,
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ));
    } else{
      return new Text("Welcome!\n" + userName!,
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ));
    }
  }

  selectButton(){
    if(admin == true){
      return new ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: secondaryTheme,
          minimumSize: Size(200, 50),
          shape: shape,
        ),
        child: new Text(
          "Change Family",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed("/selectFamily");
        },
      );
    }else{
      return new ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: secondaryTheme,
          minimumSize: Size(200, 50),
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
          Navigator.of(context).pushNamed("/selectChild");
        },
      );
    }
  }

  mainText(){
    if(admin == true){
      return new Text("Currently Managing\n" + famName! + " Family",
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ));
    }else{
      return new Text("Currently Managing\n" + babyName,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ));
    }
  }

  adminManagingText(){
    if (admin == true){
      return new Text(
          "Currently Monitoring Child: \n" +
              childName.toString(),
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ));
    }else{
      return new Text("");
    }

  }

  wellbeingRouting(){
    if (admin == true){
      Navigator.of(context).pushNamed(
          "/scorehistory");
    }else{
      Navigator.of(context).pushNamed(
          "/wellbeingsurvey");
    }
  }
}
