import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/model/forum_post.dart';
import 'package:growth_app/model/survey_question.dart';
import 'package:growth_app/theme/colors.dart';
class ForumCard extends StatelessWidget {
  const ForumCard({
    Key? key, required this.forumPost, required this.isAdmin,
  }) : super(key: key);

  final bool isAdmin;
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

                    buildDeletePositioned(context),

                    buildEditPositioned(context),
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
                          'Posted: '+forumPost.date.substring(0,10),
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
                        height: MediaQuery.of(context).size.width * 0.05,
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
                      child: SizedBox(

                        height: MediaQuery.of(context).size.height * 0.05,
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

  Positioned buildDeletePositioned(BuildContext context) {
    if (isAdmin){

      CollectionReference posts = FirebaseFirestore.instance
          .collection('forumposts');
      return Positioned(
        bottom: MediaQuery.of(context).size.width * 0.02,
        right: MediaQuery.of(context).size.width * 0.02,
        child: new IconButton(
          onPressed: (){
            deleteDialog(context,posts);
          }, icon: Icon(
          Icons.delete,
          color: Colors.grey[500],
        ),
        ),


      );

    }
    else return Positioned(
      child: Text(""),
    );
  }

  Positioned buildEditPositioned(BuildContext context) {
    if (isAdmin){
      return Positioned(
        bottom: MediaQuery.of(context).size.width * 0.02,
        right: MediaQuery.of(context).size.width * 0.1,
        child: new IconButton(
          onPressed: (){
            updateDialog(context);
          }, icon: Icon(
          Icons.edit,
          color: Colors.grey[500],
        ),
        ),


      );
    }
    else return Positioned(
        child: Text(""),
    );
    }

  void deleteDialog(BuildContext context,CollectionReference posts) {
    final _formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Forum Post?'),
            actions: [
              TextButton(
                child: Text("Yes"),
                onPressed:  () {
                  posts.doc(forumPost.id).delete().then((_) {
                  });
                  Navigator.pop(context);
                },
              ),

              TextButton(
                child: Text("Cancel"),
                onPressed:  () {Navigator.pop(context);},
              ),
            ],
          );
        });
  }
  void updateDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();


    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    titleController.text = forumPost.title;
    descriptionController.text = forumPost.description;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Forum Post'),
            content: Container(
              height: MediaQuery.of(context).size.height* 0.3,
              width: MediaQuery.of(context).size.width*0.4,
              child: Column(
                  children: [
                    Container(

                      height: MediaQuery.of(context).size.height* 0.1,
                      width: MediaQuery.of(context).size.width*0.8,
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(25),
                            ),
                          ),
                          fillColor: secondaryTheme,
                          labelText: 'Title',
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height* 0.2,
                      width: MediaQuery.of(context).size.width*0.8,
                      child: TextField(
                        maxLines: 12,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(25),
                            ),
                          ),
                          fillColor: secondaryTheme,
                          labelText: 'Description',
                        ),
                      ),
                    ),


                  ]
              ),
            ),
            actions: [

              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),

              TextButton(
                onPressed: (){
                  if (titleController.text.isEmpty || descriptionController.text.isEmpty){

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please enter forum name or description"),
                    ));
                  }else{

                    Navigator.pop(context, 'Cancel');
                    editForumPost(titleController.text, descriptionController.text);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
  editForumPost(String title, String description){

    FirebaseFirestore.instance.collection('forumposts').doc(forumPost.id).update({
      "title": title,
      "description": description,
    });

  }
}