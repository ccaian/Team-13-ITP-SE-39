import 'dart:core';

import 'package:firebase_database/firebase_database.dart';
import 'package:growth_app/navparent.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DischargeCheckListPage extends StatefulWidget {
  @override
  _DischargeCheckListPageState createState() => _DischargeCheckListPageState();
}
String?  childnric = "";
List<String> checkList = [];
List<String> checkListSaved = [];
bool admin = false;
var isEnabled = false;
var userKey;
var progressColor = Colors.redAccent;
class _DischargeCheckListPageState extends State<DischargeCheckListPage> {
  void initState(){
    super.initState();
    clearCheckList();
    loadPref();
  }
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
    'I am confident with bathing, diaper-changing and dressing my baby.' : false,
    'I have fed my baby and feel comfortable feeding my baby.' : false,
    'I know how to take my child’s temperature.' : false,
    'I have successfully given medication/vitamin to my baby. I am familiar with the dose and frequency of the medication. I understand the purpose of each medication.' : false,
    'I am familiar with the method of preparation of milk for my child. (If applicable) I know the proportion of fortification of my child’s milk.' : false,
    'I have completed parental safety/CPR training.' : false,
    'Members of the household have received updated vaccinations for influenza, pertussis/diphtheria and pneumococcal vaccines.' : false,
    'I am familiar with the equipment or care (feeding tube/tracheostomy/suctioning) my baby may need and have received adequate training on that equipment.' : false,
    'I understand my baby will go home using a car seat, I have brought a car seat to check its suitability.' : false,
  };

  double progress = 0;
  final shape =
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final _checklistRef = FirebaseDatabase.instance.reference().child('checklist');
  Color Colour = Color(0xfff2f2f2);

  @override
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
              child: Text(
                  "Discharge Checklist",
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
              )
          ),
          Positioned(
            bottom: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(

                      topRight: Radius.circular(25.0),
                      topLeft: Radius.circular(25.0)),
                ),
                child: Scaffold(
                  body: Container(
                    child: Column(
                      children: <Widget>[
                        buildcircleProgressbar(),
                        Expanded(
                          child : ListView(
                            children: List.keys.map((String key) {
                              return new  SizedBox(
                                  width: 400,
                                  child: Center(
                                  child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                              child: Container(
                              decoration: BoxDecoration(
                              color: Color(0xfff2f2f2),
                              borderRadius: BorderRadius.circular(25),
                              ),
                                  child: Center(
                                    child: CheckboxListTile(
                                      title: new Text(key, style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      )),
                                      value: List[key],
                                      activeColor: mainTheme,
                                      checkColor: Colors.white,
                                      onChanged: isEnabled ? null: (value) {
                                        setState(() {
                                          List[key] = value as bool;
                                          if(value == true){
                                            progress = progress + 100/List.length;
                                          }else{
                                            progress = progress - 100/List.length;
                                          }if(progress > 100){
                                            progress = 100.0;
                                          }if(progress < 0){
                                            progress = 0;
                                          }if(progress < 100){
                                            progressColor = Colors.redAccent;
                                          }
                                          if(progress == 100){
                                            progressColor = Colors.greenAccent;
                                          }
                                        });
                                      },
                                    ),
                                  )
                              )
                                  )
                                  )
                              ); //BoxDecoration

                            }).toList(),
                          ),),
                        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                            Widget>[
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(80.0, 10.0, 80.0, 10.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: secondaryTheme,
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
                                    onPressed: isEnabled ? null: () async {
                                      checkList =[];
                                      int i = 0;
                                      List.forEach((index, value) {
                                        print(childnric.toString() + " - " + value.toString());
                                        i++;
                                        checkList.add(value.toString());
                                      }
                                      );
                                      Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) => NavParent()
                                      ));
                                      addCheckListData(checkList, childnric);
                                    },
                                  )))
                        ]),
                      ],
                    ),
                  )
                     )
                  ),
                ),
        ],
      ),
    );
  }
  Widget buildcircleProgressbar(){
    return new Column(
      children: [
        Padding(
            padding: EdgeInsets.all(10)),
            Row( mainAxisAlignment: MainAxisAlignment.center,
              children: [Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  color: mainTheme,
                  borderRadius: BorderRadius.circular(15)
                  ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: Column(
                      children: [
                        Text('\nProgress \n', style: TextStyle(
                          fontSize: 25,fontWeight: FontWeight.bold, color: Colors.white
                        ),),
                        Text('Percentage of \ncompletion', style: TextStyle(
                            fontSize: 16, color: Colors.white
                        ),),
                      ],
                    ),
                    ),
                    VerticalDivider(width: 1.0),
                    Expanded(child: Center(child: SizedBox(
                      child: CircularPercentIndicator(
                        progressColor: progressColor,
                        radius: 120.0,
                        lineWidth: 10.0,
                        animation: true,
                        percent: progress/100,
                        center: Text(
                          progress.round().toString() + "%",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),

                      )
                    ))),
                  ],
                ),
                )
            ])
      ],
    );
  }

  addCheckListData(result, nric)  {
    print('in Data upload');
    FirebaseDatabase.instance
        .reference()
        .child("checklist")
        .orderByChild("userNRIC")
        .equalTo(nric)
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
        print('Creating data');
        if(snapshot.value == null){
          _checklistRef.push().set({
            'userNRIC' : nric,
            'checklist1': result[0],
            'checklist2': result[1],
            'checklist3': result[2],
            'checklist4': result[3],
            'checklist5': result[4],
            'checklist6': result[5],
            'checklist7': result[6],
            'checklist8': result[7],
            'checklist9': result[8],
            'progress': progress
          });
        } else{
          print('update checklist');
          updateCheckList(result, nric);
        }

    });
  }

  getCheckListData(nric)  {
    var tempKey;
    double tempProg = 0;
    print('in Data upload nric:'+ nric);
    FirebaseDatabase.instance
        .reference()
        .child("checklist")
        .orderByChild("userNRIC")
        .equalTo(nric)
        .once()
        .then((DataSnapshot snapshot) {
      //here i iterate and create the list of objects
      Map<dynamic, dynamic> childMap = snapshot.value;
      childMap.forEach((key, value) {
        tempKey = key;
        checkList.add(value['checklist1']);
        checkList.add(value['checklist2']);
        checkList.add(value['checklist3']);
        checkList.add(value['checklist4']);
        checkList.add(value['checklist5']);
        checkList.add(value['checklist6']);
        checkList.add(value['checklist7']);
        checkList.add(value['checklist8']);
        checkList.add(value['checklist9']);
        tempProg = value['progress'].toDouble();
      });
      print('child List:');
      print(checkList);
      setState(() {
        checkList = checkList;
        userKey = tempKey;
        progress = tempProg;
      });
      getCheckListState();
    });
  }

  getCheckListState() {
    bool check1 = false;
    bool check2 = false;
    bool check3 = false;
    bool check4 = false;
    bool check5 = false;
    bool check6 = false;
    bool check7 = false;
    bool check8 = false;
    bool check9 = false;
    print("In get checkListstate: ");
    print('$checkList');
    if(checkList[0]=='true'){
      check1 = true;
    } else {
      check1 = false;
    }
    print("check1 " + check1.toString());
    if(checkList[1]=='true'){
      check2 = true;
    } else {
      check2 = false;
    }
    print("check2 " + check2.toString());
    if(checkList[2]=='true'){
      check3 = true;
    } else {
      check3 = false;
    }
    print("check3 " + check3.toString());
    if(checkList[3]=='true'){
      check4 = true;
    } else {
      check4 = false;
    }
    print("check4 " + check4.toString());
    if(checkList[4]=='true'){
      check5 = true;
    } else {
      check5 = false;
    }

    if(checkList[5]=='true'){
      check6 = true;
    } else {
      check6 = false;
    }

    if(checkList[6]=='true'){
      check7 = true;
    } else {
      check7 = false;
    }

    if(checkList[7]=='true'){
      check8 = true;
    } else {
      check8 = false;
    }

    if(checkList[8]=='true'){
      check9 = true;
    } else {
      check9 = false;
    }
    setState(() {
      List = {
        'I am confident with bathing, diaper-changing and dressing my baby.' : check1,
        'I have fed my baby and feel comfortable feeding my baby.' : check2,
        'I know how to take my child’s temperature.' : check3,
        'I have successfully given medication/vitamin to my baby. I am familiar with the dose and frequency of the medication. I understand the purpose of each medication.' : check4,
        'I am familiar with the method of preparation of milk for my child. (If applicable) I know the proportion of fortification of my child’s milk.' : check5,
        'I have completed parental safety/CPR training.' : check6,
        'Members of the household have received updated vaccinations for influenza, pertussis/diphtheria and pneumococcal vaccines.' : check7,
        'I am familiar with the equipment or care (feeding tube/tracheostomy/suctioning) my baby may need and have received adequate training on that equipment.' : check8,
        'I understand my baby will go home using a car seat, I have brought a car seat to check its suitability.' : check9,
      };
    });

  }

  updateCheckList(result, nric) {
    print("in Update "+result[0].toString());
    _checklistRef.child(userKey).update(
        {'userNRIC' : nric,
          'checklist1': result[0],
          'checklist2': result[1],
          'checklist3': result[2],
          'checklist4': result[3],
          'checklist5': result[4],
          'checklist6': result[5],
          'checklist7': result[6],
          'checklist8': result[7],
          'checklist9': result[8],
          'progress': progress
        });

  }


  Future loadPref() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      childnric = sharedPreferences.getString('ChildNRIC');
      getCheckListData(sharedPreferences.getString('ChildNRIC'));
      admin = sharedPreferences.getBool('admin')!;
      if (sharedPreferences.getBool('admin') == true){
        isEnabled = true;
      }else {
        disableElevatedButton();
      }
    });
    print('In Load Pref'+ admin.toString());
  }

  enableElevatedButton() {
    setState(() {
      isEnabled = true;
    });
  }

  disableElevatedButton() {
    setState(() {
      isEnabled = false;
    });
  }

  clearCheckList(){
    setState(() {
      checkList = [];
    });
  }
}
