
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/controllers/surveycontroller.dart';
import 'package:growth_app/model/survey_score.dart';
import 'package:uuid/uuid.dart';

import 'components/score_card.dart';
import 'controllers/scorecontroller.dart';



class WellbeingScore extends StatefulWidget {


  @override
  _WellbeingScoreState createState() => _WellbeingScoreState();
}

class _WellbeingScoreState extends State<WellbeingScore> {

  final shape =
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  @override
  void initState(){

    super.initState();

  }
  @override

  Widget build(BuildContext context) {

    ScoreController _scoreController = Get.put(ScoreController());
    SurveyController _surveyController = Get.put(SurveyController());
    SurveyScore sc = SurveyScore(id: 3, score: _surveyController.totalScore, userEmail: "ccaian3@gmail.com", date: DateTime.now().toString());
    addScore(sc);
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff4C52A8),
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width*0.1,
              top: MediaQuery.of(context).size.height*0.1,
              child: Text(
                  "Score",
                  style: Theme.of(context)
                      .textTheme
                      .headline3
              ),
            ),

            Positioned(
              left: MediaQuery.of(context).size.width*0.1,
              top: MediaQuery.of(context).size.height*0.16,
              child: Text(
                  "${_surveyController.totalScore}/30",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).size.height*0.24,
              child: SizedBox(

                height: MediaQuery.of(context).size.height* 0.57,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: sample_scores.length,
                    itemBuilder: (context, index){
                      return ScoreCard(scores:_scoreController.scores[index]);
                    }),
              ),
            ),

            Align(
                alignment: Alignment.bottomCenter,

                child: Container(

                  margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.width*0.1),
                  child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(200, 50),
                  shape: shape,
              ),
              child: new Text(
                  "Go Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
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
}
void addScore(SurveyScore score){

  var uuid = Uuid();
  final databaseReference = FirebaseDatabase.instance.reference().child("wellbeingscore");
  print("testpost");
  databaseReference.child("ccaian3").child(uuid.v1()).set({
    'score': score.score,
    'date': score.date
  }


  );

}