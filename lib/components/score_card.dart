import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/model/forum_post.dart';
import 'package:growth_app/model/survey_question.dart';
import 'package:growth_app/model/survey_score.dart';
class ScoreCard extends StatelessWidget {
  const ScoreCard({
    Key? key, required this.scores,
  }) : super(key: key);

  final SurveyScore scores;
  @override
  Widget build(BuildContext context) {

    return Container(
      child: new Column(
          children: [
            new Container(

              margin: EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.15,
              child: new Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.06,
                      left: MediaQuery.of(context).size.width * 0.06,
                      child: Text(
                          scores.score.toString()+'/30',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          )
                      ),

                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.18,
                      left: MediaQuery.of(context).size.width * 0.06,
                      child: Text(
                          "Completed on "+scores.date,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[500],
                          )
                      ),

                    ),

                  ]
              ),
              decoration: BoxDecoration(
                color: Color(0xfff2f2f2),

                borderRadius: const BorderRadius.all(
                  const Radius.circular(25),
                ),
              ),
            ),


            /**[
                Positioned(
                top: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Text(
                forumPost.title,
                style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                )
                ),

                ),
                Positioned(
                top: MediaQuery.of(context).size.width * 0.13,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Text(
                forumPost.description,
                style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[500],
                )
                ),
                ),*/
          ]
      ),
    );


  }
}