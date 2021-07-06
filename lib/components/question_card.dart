
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/controllers/surveycontroller.dart';
import 'package:growth_app/model/survey_question.dart';

import 'option.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key, required this.question,
  }) : super(key: key);

  final Question question;
  @override
  Widget build(BuildContext context) {
    //print("hi");
    //print(question.options);

    SurveyController _surveyController = Get.put(SurveyController());
    return Container(
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.07, MediaQuery.of(context).size.width * 0.08,
          MediaQuery.of(context).size.width * 0.07, 0),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
      width: MediaQuery.of(context).size.width * 0.85,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(question.question,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              )
          ),
          ...List.generate(

            question.options.length,
                (index) => Option(
              index: index,
              text: question.options[index],
              press: () => _surveyController.addUpScore(question, index),
            ),
          ),
        ],
      ),
    );
  }
}
