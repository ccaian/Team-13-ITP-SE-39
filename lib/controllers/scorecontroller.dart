

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:growth_app/model/survey_question.dart';

import 'package:growth_app/model/forum_post.dart';
import 'package:growth_app/model/survey_score.dart';

class ScoreController extends GetxController
    with SingleGetTickerProviderMixin{


  @override
  void onInit() {

    final fb = FirebaseDatabase.instance.reference().child("wellbeingscore").child("ccaian3");
    fb.once().then((DataSnapshot snap){

    });
  }
}

