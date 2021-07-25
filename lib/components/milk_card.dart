import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/milkpage.dart';
import 'package:growth_app/model/forum_post.dart';
import 'package:growth_app/model/survey_question.dart';
class MilkCard extends StatelessWidget {
  const MilkCard({
    Key? key, required this.milkRecord,
  }) : super(key: key);

  final MilkRecord milkRecord;
  @override
  Widget build(BuildContext context) {

    return Container(
      child: new Column(
          children: [
            new Container(
              margin: EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.20,
              child: new Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.05,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child: Text(
                          milkRecord.weekNo,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          )
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.08,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.8,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                            "Left Breast Milk Volume: " + milkRecord.leftBreast + " ml",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[700],
                            )
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.11,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.8,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                            "Right Breast Milk Volume: " + milkRecord.rightBreast + " ml",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[700],
                            )
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.14,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.8,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                            "Total Milk Volume: " + milkRecord.totalVolume + " ml",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[700],
                            )
                        ),
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
          ]
      ),
    );


  }
}