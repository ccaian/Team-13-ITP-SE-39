import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/workerselfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/forum_card.dart';
import 'controllers/forumcontroller.dart';
import 'model/forum_post.dart';

class WorkerForum extends StatefulWidget {
  @override
  _WorkerForumState createState() => _WorkerForumState();

}
class _WorkerForumState extends State<WorkerForum> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference().child("forum");
  @override
  void initState(){
    loadPagePref();
    super.initState();
  }
  String? famName = "Miranda Family";
  String?  result = "";

  Widget build(BuildContext context) {

    ForumController _forumController = Get.put(ForumController());
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
    return Material(
      child: Container(
        color: Color(0xff4C52A8),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 80,
                left: 30,
                child: Text(
                    "Forum Page",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                )
            ),
            Positioned(
              top: 40,
              right: -10,
              child: new Image.asset('assets/healthcare.png', width: 140.0),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(

                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0)),
                  ),
                  child: Stack(
                      children: <Widget>[

                        SizedBox(

                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              itemCount: sample_posts.length,
                              itemBuilder: (context, index){
                                return ForumCard(forumPost:_forumController.posts[index]);
                              }),
                        ),
                      ]

                  )
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                // isExtended: true,
                child: Icon(Icons.add),
                backgroundColor: Color(0xff4C52A8),
                onPressed: ()  {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Enter Album Name'),
                      content: Container(
                        height: MediaQuery.of(context).size.height* 0.5,
                        width: MediaQuery.of(context).size.width*0.4,
                        child: TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(25),
                              ),
                            ),
                            fillColor: Colors.red,
                            labelText: 'Album Name',
                          ),),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: (){

                            Navigator.pop(context);
                            },
                          child: const Text('OK'),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    ),
                  );


                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  void addForumPost(ForumPost post){
    print("testpost");
    databaseReference.child("hihi").set({
      'hello': "poop"
    }


    );

  }

  Future loadPagePref() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    result = sharedPreferences.getString('Fam');
    setState(() {
      famName = result;
    });
  }
}
