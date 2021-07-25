
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/controllers/surveycontroller.dart';
import 'package:growth_app/model/survey_score.dart';
import 'package:growth_app/scorehistory.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'components/score_card.dart';
import 'controllers/scorecontroller.dart';



class WellbeingScore extends StatefulWidget {


  @override
  _WellbeingScoreState createState() => _WellbeingScoreState();
}

class _WellbeingScoreState extends State<WellbeingScore> {

  late CollectionReference scores;
  var email;
  final shape =
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(50));
  @override
  void initState(){

    getEmail();
    super.initState();

  }
  @override

  Widget build(BuildContext context) {

    print("TESTING");
    print(email);
    scores = FirebaseFirestore.instance
        .collection('wellbeingscore').doc(email).collection('scores');
    SurveyController _surveyController = Get.put(SurveyController());
    addScore(_surveyController.totalScore);
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: mainTheme,
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width*0.12,
              top: MediaQuery.of(context).size.height*0.12,
              child: Text(
                  "Score",
                  style: Theme.of(context)
                      .textTheme
                      .headline2
              ),
            ),

            Positioned(
              left: MediaQuery.of(context).size.width*0.12,
              top: MediaQuery.of(context).size.height*0.2,
              child: Text(
                  "${_surveyController.totalScore}/30",
                  style: Theme.of(context)
                      .textTheme
                      .headline3
              ),
            ),

            Positioned(
              left: MediaQuery.of(context).size.width*0.1,
              top: MediaQuery.of(context).size.height*0.3,
              child: Container(
                padding: EdgeInsets.all( MediaQuery.of(context).size.width*0.05),
                height: MediaQuery.of(context).size.height*0.15,
                width: MediaQuery.of(context).size.width*0.8,
                child: new Text(
                  
                  "10 or greater is possible depression\n\n13 or greater are more likely to suffer from a depressive illness",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(

                  color: mainTheme500,

                  borderRadius: const BorderRadius.all(
                    const Radius.circular(25),
                  ),
                ),
              )
            ),

            Align(
                alignment: Alignment.center,

                child: Container(

                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width*0.2, 0, 0),
                  child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(280, 100),
                  shape: shape,
              ),
              child: new Text(
                  "View Scores",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[800],
                  ),
              ),
              onPressed: () async {
                  if (_surveyController.isFinished){

                    Navigator.pop(context);
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => ScoreHistory()
                    ));
                  }
              },
            ),
                )),

            Align(
                alignment: Alignment.center,

                child: Container(

                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*0.4, 0, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(280, 100),
                      shape: shape,
                    ),
                    child: new Text(
                      "Go Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[800],
                      ),
                    ),
                    onPressed: () async {
                      if (_surveyController.isFinished){

                        Navigator.pop(context);
                      }
                    },
                  ),
                )),
            Align(
              alignment: Alignment.bottomLeft,

                child: Container(
                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.06, 0, 0, MediaQuery.of(context).size.width*0.03),
                  child: TextButton(
                    child: new Text(
                    "Disclaimer",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Disclaimer'),
                        content: const Text('The suggested results are not a substitute for clinical judgement. None of the  parties involved in the preparation of this shall be liable for any special consequences , or exemplary.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                )
            )
          ],
        ),
      ),

    );

  }
  void addScore(int score){

    DateTime now = new DateTime.now();
    scores.add({
      'score': score,
      'date' : now.toString()
    });
  }
  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    setState(() {

      email = prefs.getString('email');
    });
    print(email);
    print("testingemail");
  }
}
