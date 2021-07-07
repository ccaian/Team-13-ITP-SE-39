import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/controllers/forumcontroller.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/model/forum_post.dart';
import 'package:growth_app/model/survey_question.dart';
class ForumCard extends StatelessWidget {
  const ForumCard({
    Key? key, required this.forumPost,
  }) : super(key: key);

  final ForumPost forumPost;
  @override
  Widget build(BuildContext context) {

    return Container(
      child: new Column(
          children: [
            new Container(

              margin: EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.25,
              child: new Stack(
                  children: [
                    Positioned(
                        top: MediaQuery.of(context).size.width * 0.05,
                        left: MediaQuery.of(context).size.width * 0.05,
                      child: CircularProfileAvatar(
                      'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                        radius: 23, // sets radius, default 50.0
                        backgroundColor: Colors.transparent, // sets background color, default Colors.white
                        borderWidth: 1,  // sets border, default 0.0
                        borderColor: Colors.white, // sets border color, default Colors.white
                        foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                        cacheImage: true, // allow widget to cache image against provided url
                      )

                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.05,
                      left: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                          forumPost.author,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          )
                      ),

                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.11,
                      left: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                          'Posted: '+forumPost.date,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[500],
                          )
                      ),

                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.11,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.8,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                            forumPost.title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
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
                            forumPost.description,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[500],
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