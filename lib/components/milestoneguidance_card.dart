import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/milestonepdf.dart';
import 'package:growth_app/model/forum_post.dart';
import 'package:growth_app/model/milestone.dart';
import 'package:growth_app/model/survey_question.dart';
import 'package:growth_app/theme/colors.dart';
class MilestoneCard extends StatelessWidget {
  const MilestoneCard({
    Key? key, required this.milestone, required this.isAdmin, required this.context,
  }) : super(key: key);

  final BuildContext context;
  final bool isAdmin;
  final Milestone milestone;
  @override
  Widget build(BuildContext context) {

    return Container(
      child: new Column(
          children: [
            InkWell(
              onTap: (){
                  downloadURLExample();
              },
              child: new Container(

                margin: EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
                child: new Stack(
                    children: [

                      buildDeletePositioned(context),

                      buildEditPositioned(context),

                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.05,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                              milestone.title,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              )
                          ),
                        ),

                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.07,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: SizedBox(

                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                              milestone.description,
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
            ),


          ]
      ),
    );


  }
  Future<void> downloadURLExample() async {

    print("TEST");
    print(milestone.filename);
    String downloadURL = await FirebaseStorage.instance
        .ref('milestones/'+milestone.filename)
        .getDownloadURL();

    Navigator.push(context, new MaterialPageRoute(
        builder: (context) => MilestonePDF(pdfurl: downloadURL,)
    ));
    print(downloadURL);

    // Within your widgets:
    // Image.network(downloadURL);
  }
  Positioned buildDeletePositioned(BuildContext context) {
    if (isAdmin){

      CollectionReference milestones = FirebaseFirestore.instance
          .collection('milestones');
      return Positioned(
        bottom: MediaQuery.of(context).size.width * 0.02,
        right: MediaQuery.of(context).size.width * 0.02,
        child: new IconButton(
          onPressed: (){
            deleteDialog(context,milestones);
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

  void deleteDialog(BuildContext context,CollectionReference milestones) {
    final _formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Milestone?'),
            actions: [
              TextButton(
                child: Text("Yes"),
                onPressed:  () {
                  milestones.doc(milestone.id).delete().then((_) {
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

    titleController.text = milestone.title;
    descriptionController.text = milestone.description;
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

    FirebaseFirestore.instance.collection('milestones').doc(milestone.id).update({
      "title": title,
      "description": description,
    });

  }
}