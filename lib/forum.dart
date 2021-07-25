import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:growth_app/workerselfamily.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'components/forum_card.dart';
import 'model/forum_post.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();

}
class _ForumState extends State<Forum> {
  var email;
  bool isAdmin = false;
  String title = '';
  String description = '';
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference().child("forum");
  CollectionReference posts = FirebaseFirestore.instance
      .collection('forumposts');
  @override
  void initState(){
    loadPagePref();
    getEmail();
    super.initState();
  }
  String? famName = "Miranda Family";
  String?  result = "";

  Widget build(BuildContext context) {


    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
    return Material(
      child: Container(
        color: mainTheme,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 70,
              left: 10,
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              ),



            ),
            Positioned(
                top: 80,
                left: 50,
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
                            stream: posts.orderBy('date', descending: true).snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                              //if (snapshot.connectionState == ConnectionState.done){

                              //}
                              List forumposts = snapshot.data!.docs;
                              List<ForumPost> _posts = forumposts.map(
                                    (forumpost) => ForumPost(
                                    id: forumpost.id,
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
                                  return ForumCard(forumPost: _posts[index],isAdmin: isAdmin,);
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
              child: buildFloatingActionButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    if (isAdmin){
      return FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: mainTheme,
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
                    Navigator.pop(context, 'Cancel');
                    if (titleController.text.isEmpty || descriptionController.text.isEmpty){

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please enter album name or description"),
                      ));
                    }else{

                      addForumPost(titleController.text, descriptionController.text);
                    }
                  },
                  child: const Text('OK'),
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

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    setState(() {

      isAdmin = prefs.getBool('admin')!;
      email = prefs.getString('email');
    });
    print(email);
    print("hello");
  }
  Future loadPagePref() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    result = sharedPreferences.getString('Fam');
    setState(() {
      famName = result;
    });
  }
}
