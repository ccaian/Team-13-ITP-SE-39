
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


            Align(
                alignment: Alignment.center,

                child: Container(

                  margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.width*0.15),
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

                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width*0.5, 0, 0),
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
                ))
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
