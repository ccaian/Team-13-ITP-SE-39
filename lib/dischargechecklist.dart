import 'package:firebase_database/firebase_database.dart';
import 'package:growth_app/navparent.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DischargeCheckListPage extends StatefulWidget {
  @override
  _DischargeCheckListPageState createState() => _DischargeCheckListPageState();
}
var _checklistRef = FirebaseDatabase.instance.reference().child('checklist');
String?  childnric = "";
class _DischargeCheckListPageState extends State<DischargeCheckListPage> {
  void initState(){
    loadPref();
    super.initState();
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
  Color Colour = Color(0xfff2f2f2);

  @override
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
                        const  SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child : ListView(
                            children: List.keys.map((String key) {
                              return new  SizedBox(
                                  width: 400,
                                  child: Center(
                                  child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                              child: Container(
                              decoration: BoxDecoration(
                              color: Color(0xfff2f2f2),
                              borderRadius: BorderRadius.circular(25),
                              ),
                                  child: CheckboxListTile(
                                    title: new Text(key, style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    )),
                                    value: List[key],
                                    activeColor: Colors.deepPurple[400],
                                    checkColor: Colors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        List[key] = value as bool;
                                        if(value == true){
                                          progress = progress + 100/List.length;
                                        }else{
                                          progress = progress - 100/List.length;
                                        }if(progress > 100){
                                          progress = 100;
                                        }if(progress < 0){
                                          progress = 0;
                                        }
                                      });
                                    },
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
                                      int i = 0;
                                      List.forEach((index, value) {
                                        print(childnric.toString() + " - " + value.toString());
                                        i++;
                                      }
                                      );
                                      Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) => NavParent()
                                      ));
                                      //addCheckListData(value.toString(), i, childnric);
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
                  color: Color(0xff4C52A8),
                  borderRadius: BorderRadius.circular(15)
                  ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: Column(
                      children: [
                        Text('\nProgress \n', style: TextStyle(
                          fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white
                        ),),
                        Text('Percentage of \ncompletion', style: TextStyle(
                            fontSize: 12, color: Colors.white
                        ),),
                      ],
                    ),
                    ),
                    VerticalDivider(width: 1.0),
                    Expanded(child: Center(child: SizedBox(
                      child: CircularPercentIndicator(
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

  addCheckListData(result, index, nric)  {
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
        _checklistRef.push().set({
          'userNRIC' : nric,
          'checklist '+ index.toString(): result
        });



    });
  }


  Future loadPref() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      childnric = sharedPreferences.getString('ChildNRIC');
    });
    print('In Load Pref');
  }

  /*Widget buildChecklist() {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    return new Column(children: <Widget>[
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
          ]
        );
  }*/
}
