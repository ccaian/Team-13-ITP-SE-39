import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName = "";
  String? userEmail = "";
  String? nameOfChild = "";
  String babyName = "";
  String? famName = "";
  String? childName = "";
  bool admin = false;
  final shape =
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));

  final _selectFamily = FirebaseFirestore.instance.collection('user');

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
    userEmail = sharedPreferences.getString('email');
    nameOfChild = sharedPreferences.getString('ChildName');
    QuerySnapshot querySnapshot = await _selectFamily.where('email', isEqualTo: userEmail).get();

    // Get data from docs and convert map to List
    newList = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        userName = newList[0]['firstName'].toString();
        babyName = nameOfChild!;
        admin = sharedPreferences.getBool('admin')!;
        famName = sharedPreferences.getString('Fam');
        childName = sharedPreferences.getString('ChildName');
      });
  }

  welcomeText(){
    if(admin == true){
      return new Text("Welcome!\nAdmin" ,
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
      return new Text("Currently Viewing\nFamily of " + famName!,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ));
    }else{
      return new Text("Currently Viewing\n" + babyName,
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
