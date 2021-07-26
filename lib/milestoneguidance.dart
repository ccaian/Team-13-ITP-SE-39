import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/api/firebase_api.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/milestonepdf.dart';
import 'package:growth_app/model/milestone.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/milestoneguidance_card.dart';



class MilestoneGuidance extends StatefulWidget {


  @override
  _MilestoneGuidanceState createState() => _MilestoneGuidanceState();
}

class _MilestoneGuidanceState extends State<MilestoneGuidance> {
  UploadTask? task;
  File? file;
  late CollectionReference guidance;
  bool isAdmin = false;
  var _openResult = 'Unknown';
  //final firebaseDB = FirebaseDatabase.instance.reference().child('milestones');
  @override
  void initState(){
    super.initState();
    isAdminCheck();

  }
  @override
  Widget build(BuildContext context) {

    guidance = FirebaseFirestore.instance.collection('milestones');
    return Material(
      child: Container(
          color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            new Row(
              children: [
                Padding(
                padding: const EdgeInsets.fromLTRB(45.0,50.0,0.0,0.0),
                child: Align(

                  alignment: Alignment.topCenter,
                  child: new Image.asset('assets/nurses.png', width: MediaQuery.of(context).size.width * 0.8),
                ),
              ),

              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0.0,10.0,0.0,20.0),
              child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(

                color: mainTheme,

                borderRadius: const BorderRadius.all(
                  const Radius.circular(25),
                ),
              ),
              child: new Stack(
                children: [
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: buildFloatingActionButton(context),
                  ),
                  Positioned(

                    top: MediaQuery.of(context).size.width * 0.05,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: Text(
                        "Milestone Guidances",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.14,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: Text(
                        "Welcome to the NUHS Childcare Application, \ndo read up on the following topics\nto aid in your childcare journey.",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              child: new SizedBox(

                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                    stream: guidance.orderBy('title', descending: false).snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                      //if (snapshot.connectionState == ConnectionState.done){

                      //}
                      List milestones = snapshot.data!.docs;
                      List<Milestone> _milestones = milestones.map(
                            (milestone) => Milestone(
                            id: milestone.id,
                            filename: milestone['filename'],
                            title: milestone['title'],
                            description: milestone['description']),
                      )
                          .toList();
                      //print(data['title']);
                      return ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index){
                          return MilestoneCard(milestone: _milestones[index],isAdmin: isAdmin,context: context,);
                        },
                      );
                      return Text("loading");


                    }
                    ,

                  )

              ),
            ),

          ]
        )
      ),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    if (isAdmin){
      return FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.upload),
        elevation: 0,
        backgroundColor: mainTheme,
        onPressed: ()  {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Enter Milestone Details'),
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
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: (){
                    if (titleController.text.isEmpty || descriptionController.text.isEmpty){

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please enter album name or description"),
                      ));
                    }else{
                      selectFile(context,titleController.text,descriptionController.text);
                    }
                  },
                  child: const Text('Choose PDF'),
                ),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
            ),
          );
        },
      );
    }
    else return Text(
        " "
    );


  }
  Future selectFile(BuildContext context,String title, String description) async {

    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path =  result.files.single.path!;

    setState(() => file = File(path));

    addMilestone(title, description, basename(file!.path));
    uploadFile(context);
  }
  void addMilestone(String title, String description,String filename){
    guidance.add({

      'title': title,
      'description': description,
      'filename': filename,


    });


  }
  Future uploadFile(BuildContext context) async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'milestones/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    Navigator.pop(context);
  }
  isAdminCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    setState(() {

      isAdmin = prefs.getBool('admin')!;
    });
  }


}
