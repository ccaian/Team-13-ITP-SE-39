import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/workerselfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'components/forum_card.dart';
import 'controllers/forumcontroller.dart';
import 'model/forum_post.dart';

class WorkerForum extends StatefulWidget {
  @override
  _WorkerForumState createState() => _WorkerForumState();

}
class _WorkerForumState extends State<WorkerForum> {

  String title = '';
  String description = '';
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference().child("forum");
  CollectionReference posts = FirebaseFirestore.instance
      .collection('forumposts')
      ;
  @override
  void initState(){
    loadPagePref();
    super.initState();
  }
  String? famName = "Miranda Family";
  String?  result = "";

  Widget build(BuildContext context) {


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
                          child: StreamBuilder(
                            stream: posts
                              .snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                              //if (snapshot.connectionState == ConnectionState.done){

                              //}
                              List forumposts = snapshot.data!.docs;
                              List<ForumPost> _posts = forumposts.map(
                                    (forumpost) => ForumPost(
                                    id: 123,
                                    date: forumpost['date'],
                                    author: 'Admin',
                                    title: forumpost['title'],
                                    description: forumpost['description']),
                              )
                                  .toList();
                              //print(data['title']);
                              return ListView.builder(
                                itemCount: snapshot.data!.size,
                                itemBuilder: (context, index){
                                  return ForumCard(forumPost: _posts[index],);
                                },
                              );
                              return Text("loading");


                            }
                            ,

                          )

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
                      title: const Text('Enter Post Details'),
                      content: Container(
                        height: MediaQuery.of(context).size.height* 0.3,
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Column(
                          children: [
                            Container(

                              height: MediaQuery.of(context).size.height* 0.1,
                              width: MediaQuery.of(context).size.width*0.8,
                              child: TextField(
                                onChanged: (val) {
                                  setState(() => title);
                                },
                              controller: titleController,
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(25),
                                  ),
                                ),
                                fillColor: Colors.red,
                                labelText: 'Title',
                              ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height* 0.2,
                              width: MediaQuery.of(context).size.width*0.8,
                              child: TextField(
                                maxLines: 12,
                                onChanged: (val) {
                                  setState(() => description);
                                },
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(25),
                                    ),
                                  ),
                                  fillColor: Colors.red,
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
                            Navigator.pop(context, 'Cancel');
                            if (titleController.text != '' && descriptionController != '')
                              print("bumbblebee");
                              addForumPost(titleController.text, descriptionController.text);
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

  void addForumPost(String title, String description){
    print("chocolate 2");
    DateTime now = new DateTime.now();
    posts.add({

      'title': title,
      'description': description,
      'author': 'Admin',
      'date': now.toString(),


    });


  }

  Future loadPagePref() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    result = sharedPreferences.getString('Fam');
    setState(() {
      famName = result;
    });
  }
}