import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:growth_app/controllers/surveycontroller.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/model/survey_question.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/scorehistory.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:growth_app/wellbeingscore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/question_card.dart';



class WellbeingSurvey extends StatefulWidget {


  @override
  _WellbeingSurveyState createState() => _WellbeingSurveyState();
}

class _WellbeingSurveyState extends State<WellbeingSurvey> {
  final shape =
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  @override
  void initState(){

    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    SurveyController _surveyController = Get.put(SurveyController());
    _surveyController.resetSurvey();
    _surveyController.setContext(context);
    print(_surveyController.questions.length);
    return Scaffold(

      body: Container(
          color: mainTheme,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
              children: <Widget>[

                Positioned(
                  top: 70,
                  left: 10,
                  child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  ),



                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: MediaQuery.of(context).size.width * 0.13,
                  child: Text(
                      "Wellbeing Survey",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
                )),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.15,
                    left: MediaQuery.of(context).size.width * 0.1,
                    child: Obx(() => Text(
                        "Question ${_surveyController.questionNumber.value} / ${_surveyController.questions.length}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        )
                    ))),
                
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.20,
                  left: MediaQuery.of(context).size.width * 0.0,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding:EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1, 0, MediaQuery.of(context).size.width * 0.1, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Color(0xffc5c2e2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Stack(
                              children: [
                                GetBuilder<SurveyController>(
                                  init: SurveyController(),
                                  builder: (controller){

                                    return LayoutBuilder(
                                      builder: (context, constraints) => Container(
                                        width: constraints.maxWidth * controller.length,
                                        decoration: BoxDecoration(
                                          color: secondaryTheme,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                    );
                                  },



                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              onPageChanged: _surveyController.updateQnsNumber,
                              controller: _surveyController.pageController,
                              itemCount: _surveyController.questions.length,
                              itemBuilder: (context, index) => QuestionCard(
                                  question: _surveyController.questions[index]),

                        ))
                        ,
                        Row(
                          children: [


                            Container(
                              margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width*0.08, 0, 0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: secondaryTheme,
                                  minimumSize: Size(250, 50),
                                  shape: shape,
                                ),
                                child: new Text(
                                  "Score History",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: ()  {
                                    Navigator.push(context, new MaterialPageRoute(
                                        builder: (context) => ScoreHistory()
                                    ));

                                },
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),

                )
              ]
          )
      ),
    );
  }
}



