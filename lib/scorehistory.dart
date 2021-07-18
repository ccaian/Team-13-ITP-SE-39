
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/controllers/surveycontroller.dart';
import 'package:growth_app/model/survey_score.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'components/score_card.dart';
import 'controllers/scorecontroller.dart';



class ScoreHistory extends StatefulWidget {


  @override
  _ScoreHistoryState createState() => _ScoreHistoryState();
}

class _ScoreHistoryState extends State<ScoreHistory> {
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

    CollectionReference scores = FirebaseFirestore.instance
        .collection('wellbeingscore').doc(email).collection('scores');
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff4C52A8),
        child: Stack(
          children: [

            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              child: SizedBox(

                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: scores
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    List scorelist = snapshot.data!.docs;
                    List<SurveyScore> _scores = scorelist.map(
                          (score) => SurveyScore(
                          date: score['date'],
                          score: score['score']),
                    )
                        .toList();
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index){
                        return ScoreCard(scores: _scores[index],);
                      },
                    );
                  }

                ),

              ),
            ),

            Align(
                alignment: Alignment.bottomCenter,

                child: Container(

                  margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.width*0.2),
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
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[800],
                      ),
                    ),
                    onPressed: () async {

                      Navigator.pop(context);
                    },
                  ),
                ))
          ],
        ),
      ),

    );

  }
  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    bool isAdmin = false;

    setState(() {
      isAdmin = prefs.getBool('admin')!;
      if (isAdmin)
        email = prefs.getString('parentemail');
      else
        email = prefs.getString('email                  ');

    });
    print(email);
  }
}
