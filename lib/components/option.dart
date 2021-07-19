
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/controllers/surveycontroller.dart';

class Option extends StatelessWidget {
  const Option({
    Key? key, required this.text, required this.index, required this.press,
  }) : super(key: key);
  final String text;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SurveyController>(
      init: SurveyController(),
      builder: (surveyController) {
        /**
        Color highlightSelect(){
          if (surveyController.isAnswered){
            if (index == surveyController.selectedAns)
                return Color.fromRGBO(197, 194, 226, 1);
          }
          return Color.fromRGBO(242, 242, 242, 1);
        }*/
        return InkWell(
          onTap: press,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.04, 0, 0),
            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.06,
                MediaQuery.of(context).size.width * 0.04,
                MediaQuery.of(context).size.width * 0.06,
                MediaQuery.of(context).size.width * 0.04),
            decoration: BoxDecoration(
              color: Color.fromRGBO(242, 242, 242, 1),
              border: Border.all(color: Color.fromRGBO(242, 242, 242, 1)),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: Text(text,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[800],
                      )
                  ),
                ),
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey)
                  ),
                )
              ],
            ),

          ),
        );
      }
    );
  }
}