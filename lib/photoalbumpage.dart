
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/photodetail.dart';
import 'package:growth_app/uploadphoto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/firebase_api.dart';
import 'model/firebase_file.dart';
import 'model/photo.dart';


class PhotoAlbum extends StatefulWidget {

  //final FirebaseFile file;
  final String refUrl;
  const PhotoAlbum({
        Key? key,
        required this.refUrl,
      }) : super(key: key);

  @override
  _PhotoAlbumState createState() => _PhotoAlbumState();
}

class _PhotoAlbumState extends State<PhotoAlbum> {


  late CollectionReference photos;
  var email;
  var nric;
  String selectedimageurl = "";
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    //futurePaths = FirebaseApi.listWeek('ccaian3@gmail.com/');
    getNRIC();
    futureFiles = FirebaseApi.listAll(widget.refUrl+"/");
    //futureFiles = FirebaseApi.listAll('ccaian3@gmail.com/week_1/');
  }

  @override
  Widget build(BuildContext context) {

    String week = widget.refUrl.substring(widget.refUrl.indexOf('/')+1,widget.refUrl.length);
    photos = FirebaseFirestore.instance.collection('photos').doc(nric).collection(week);
    return Scaffold(
      body: Container(
        color: Color(0xff4C52A8),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 80,
                left: 30,
                child: Text(
                    week.replaceAll("_", " "),
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
              child: new Image.asset('assets/milkbottle.png', width: 140.0),
            ),
            Positioned(
              bottom: 0,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(

                          topRight: Radius.circular(25.0),
                          topLeft: Radius.circular(25.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,0.0),
                      child:StreamBuilder(
                        stream: photos
                            .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                          switch (snapshot.connectionState){
                            case ConnectionState.waiting:

                              return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError){
                                return Center(child: Text('Some error occurred!'));

                              }
                              else{
                                print("testing");
                                List photolist = snapshot.data!.docs;
                                List<Photo> _photos = photolist.map(
                                      (photo) => Photo(
                                      date: photo.get('date'),
                                      description: photo.get('description'),
                                      filename: photo.get('filename'),
                                      name: photo.get('name')),
                                )
                                    .toList();

                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),

                                  child: GridView.builder(
                                    itemCount: _photos.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20.0,
                                      mainAxisSpacing: 20.0,
                                    ),
                                    itemBuilder: (context, index) {
                                      return buildFile(context, _photos[index]);
                                    },
                                  ),
                                );
                              }
                          }

                        }
                      ),


                      /*FutureBuilder<List<FirebaseFile>>(
                        future: futureFiles,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:

                              return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError) {
                                return Center(child: Text('Some error occurred!'));
                              } else {
                                final files = snapshot.data!;

                                print(snapshot.data!.length);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0,20.0,0,0),
                                        child: GridView.builder(
                                          itemCount: files.length,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 1,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 20.0,
                                            mainAxisSpacing: 20.0,
                                          ),
                                          itemBuilder: (context, index) {
                                            final file = files[index];
                                            return buildFile(context, file, index);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                        */
                    )
                ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      // isExtended: true,
                      child: Icon(Icons.add),
                      backgroundColor: Color(0xff4C52A8),
                      onPressed: () {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => UploadPhoto(refUrl: widget.refUrl)
                        ));
                      },
                    ),
                  ),
        ]
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFile(BuildContext context, Photo photo) => Stack(
    children: [
      InkWell(
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => PhotoDetail(photo: photo)
          ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
                photo.filename,
                fit: BoxFit.fill
            ),
          ),

          /*Image.network(
          file.url,
          height: 200.0,
          width: 200.0,
        ),*/
        ),
      )

    ],
  );
  getNRIC() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();


    setState(() {
      nric = prefs.getString('ChildNRIC');

    });
  }
  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    bool isAdmin = false;

    setState(() {
      isAdmin = prefs.getBool('admin')!;
      if (isAdmin)
        email = prefs.getString('parentemail');
      else
        email = prefs.getString('email');

    });
    print(email);
  }


  Widget buildHeader(int length) => ListTile(
    tileColor: Colors.blue,
    leading: Container(
      width: 52,
      height: 52,
      child: Icon(
        Icons.file_copy,
        color: Colors.white,
      ),
    ),
    title: Text(
      '$length Files',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}

