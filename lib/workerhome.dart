import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/scorehistory.dart';
import 'package:growth_app/wellbeingsurvey.dart';
import 'package:growth_app/workerdischargechecklist.dart';
import 'package:growth_app/workerforum.dart';
import 'package:growth_app/workerselfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerHome extends StatefulWidget {
  @override
  _WorkerHomeState createState() => _WorkerHomeState();

}
class _WorkerHomeState extends State<WorkerHome> {
  @override
  void initState(){
    loadPagePref();
    super.initState();
  }
  String? famName = "";
  String?  result = "";
  String?  childName = "";

  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
    return Material(
      child: Container(
        color: Color(0xff4C52A8),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 80,
                left: 30,
                child: Text(
                    "Welcome,\nAdmin",
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
                                "Currently Monitoring Child: \n" +childName.toString(),
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
                                "Change Patient",
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
                          top: MediaQuery.of(context).size.height * 0.37,
                          left: MediaQuery.of(context).size.width * 0.05,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => WorkerForum()
                              ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.425,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(25.0,20.0,0.0,0.0),
                                  child: Text(
                                      "Forum",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.grey[600],
                                      )
                                  )),
                              decoration: BoxDecoration(
                                color: Color(0xfff2f2f2),
                                
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(25),
                                ),
                              ),

                            ),
                          ),),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.37,
                          left: MediaQuery.of(context).size.width * 0.525,
                          child: InkWell(
                            onTap: () {
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => ScoreHistory()
                            ));
                          },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.425,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(25.0,20.0,0.0,0.0),
                                  child: Text(
                                      "Wellbeing Survey",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.grey[600],
                                      )
                                  )),
                              decoration: BoxDecoration(
                                color: Color(0xfff2f2f2),

                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(25),
                                ),
                              ),

                            ),
                          ),),

                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.5,
                          left: MediaQuery.of(context).size.width * 0.05,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => WorkerDischargeCheckListPage()));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.425,
                              height: MediaQuery.of(context).size.height * 0.17,
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(25.0,20.0,0.0,0.0),
                                  child: Text(
                                      "Discharge Checklist",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.grey[600],
                                      )
                                  )),
                              decoration: BoxDecoration(
                                color: Color(0xfff2f2f2),

                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(25),
                                ),
                              ),

                            ),
                          ),),
                      ]

                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildText(BuildContext context) => Text(
      "Currently Managing\n" + famName! + " Family",
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
        builder: (context) => WorkerSelFamily()
    ));



    (context as Element).reassemble();
    print(result);
  }

  Future loadPagePref() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    result = sharedPreferences.getString('Fam');
    childName = sharedPreferences.getString('ChildName');
    setState(() {
      famName = result;
      childName = sharedPreferences.getString('ChildName');
    });
  }
}