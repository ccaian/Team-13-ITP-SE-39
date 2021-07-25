
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/controllers/surveycontroller.dart';
import 'package:growth_app/model/survey_score.dart';
import 'package:growth_app/theme/colors.dart';
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

    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    print("testing");
    print(email);
      CollectionReference scores = FirebaseFirestore.instance
        .collection('wellbeingscore').doc(email).collection('scores');
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: mainTheme,
        child: Stack(
          children: [

            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              child: SizedBox(

                height: MediaQuery.of(context).size.height * 0.5,
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

            Positioned(
                left: MediaQuery.of(context).size.width*0.1,
                top: MediaQuery.of(context).size.height*0.65,
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
        email = prefs.getString('email');

    });
    print(email);
  }
}
