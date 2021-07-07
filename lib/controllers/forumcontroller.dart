

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:growth_app/model/survey_question.dart';

import 'package:growth_app/model/forum_post.dart';

class ForumController extends GetxController
    with SingleGetTickerProviderMixin{


  List<ForumPost> _posts = sample_posts
      .map(
        (forumpost) => ForumPost(
        id: forumpost['id'],
            date: forumpost['date'],
            author: forumpost['author'],
            title: forumpost['title'],
            description: forumpost['description']),
  )
      .toList();
  List<ForumPost> get posts => this._posts;

}

