
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/photoalbumpage.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:growth_app/uploadphoto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/firebase_api.dart';
import 'model/firebase_file.dart';


class PhotoPage extends StatefulWidget {

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {

  late CollectionReference photos;
  var nric;
  var email;
  final albumNameController = TextEditingController();

  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    getNRIC();
    super.initState();
    //futurePaths = FirebaseApi.listWeek('ccaian3@gmail.com/');

  }

  @override
  Widget build(BuildContext context) {

    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    if (nric!=null){
      FirebaseApi.listWeek(nric+'/');
      print("NRIC");
      print(nric);
      futureFiles = FirebaseApi.listWeek(nric+'/');
    }

    return Container(
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
                  "Photo Albums",
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
            child: Container(
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
                  child:FutureBuilder<List<FirebaseFile>>(
                    future: futureFiles,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {return InkWell(
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Enter Album Name'),
                                    content: TextField(
                                      controller: albumNameController,
                                      decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(25),
                                          ),
                                        ),
                                        fillColor: Colors.red,
                                        labelText: 'Album Name',
                                      ),),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: (){

                                          Navigator.pop(context);
                                          Navigator.push(context, new MaterialPageRoute(
                                              builder: (context) => UploadPhoto(refUrl: nric+'/'+albumNameController.text.replaceAll(' ', '_'))
                                          ));},
                                        child: const Text('OK'),
                                      ),
                                    ],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 0,
                                      child: Image.asset('assets/newalbum.png'),width:MediaQuery.of(context).size.width *0.4 ),
                                ],
                              )
                          );
                          } else {
                            final files = snapshot.data!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0,20.0,0,0),
                                    child: GridView.builder(
                                      itemCount: files.length + 1,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 3/4,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20.0,
                                        mainAxisSpacing: 0.0,
                                      ),
                                      itemBuilder: (context, index) {
                                        if (index == 0){
                                          return InkWell(
                                              onTap: () {
                                                showDialog<String>(
                                                  context: context,
                                                  builder: (BuildContext context) => AlertDialog(
                                                    title: const Text('Enter Album Name'),
                                                    content: TextField(
                                                      controller: albumNameController,
                                                      decoration: InputDecoration(
                                                        border: new OutlineInputBorder(
                                                          borderRadius: const BorderRadius.all(
                                                            const Radius.circular(25),
                                                          ),
                                                        ),
                                                        fillColor: Colors.red,
                                                        labelText: 'Album Name',
                                                      ),),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                                        child: const Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: (){

                                                          Navigator.pop(context);
                                                          Navigator.push(context, new MaterialPageRoute(
                                                            builder: (context) => UploadPhoto(refUrl: nric+'/'+albumNameController.text.replaceAll(' ', '_'))
                                                        ));},
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                      top: 0,
                                                      child: Image.asset('assets/newalbum.png'),width:MediaQuery.of(context).size.width *0.4 ),
                                                ],
                                              )
                                          );
                                        }
                                        else{
                                          final file = files[index-1];
                                          print(file.url);
                                          return buildFile(context, file, index-1);

                                        }
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

                )
            ),
          )
        ],
      ),
    );
  }


  Widget buildFile(BuildContext context, FirebaseFile file, int index) => InkWell(

    onTap: () => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PhotoAlbum(refUrl: file.ref.fullPath),
    )),
    child: Stack(
      children: [
        ClipRRect(

          borderRadius: BorderRadius.circular(30.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(

              file.url,
              fit: BoxFit.fill
            ),
          ),
        ),

          Align(
            alignment: Alignment(0.0,0.8),
            child: Text(
              file.ref.name.replaceAll("_", " "),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),

      ],
    ),
  );

  getNRIC() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nric = prefs.getString('ChildNRIC');
      print("NRIC");
      print(nric);

    });
  }
  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    bool isAdmin = false;

    setState(() {
      isAdmin = prefs.getBool('admin')!;
      if (isAdmin){
        email = prefs.getString('ChildNRIC');}
      else
        email = prefs.getString('ChildNRIC');

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

