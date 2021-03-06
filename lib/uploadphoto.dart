

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/photoalbumpage.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'api/firebase_api.dart';
import 'model/firebase_file.dart';


class UploadPhoto extends StatefulWidget {

  final String refUrl;
  const UploadPhoto({
    Key? key,
    required this.refUrl,
  }) : super(key: key);

  @override
  _UploadPhotoState createState() => _UploadPhotoState();
  
}

class _UploadPhotoState extends State<UploadPhoto> {

  late CollectionReference photos;
  var email;
  var nric;
  final descriptionController = TextEditingController();

  final nameController = TextEditingController();
  String imageUrl = '';
  final shape = RoundedRectangleBorder(
      borderRadius:  BorderRadius.circular(25)
  );
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    print("refurl");
    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    String title = widget.refUrl.substring(widget.refUrl.indexOf('/')+1,widget.refUrl.length);
    photos = FirebaseFirestore.instance.collection('photos').doc(nric).collection(title);

    final maxLines = 7;
    return Scaffold(
      body: Container(
        color: mainTheme,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[


            Positioned(
                top: 80,
                left: 30,
                child: Text(
                    "Upload Photo",
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
              child:
              Container(
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
                      (imageUrl != '')
                          ? Positioned(
                          top: 30,
                          left: 20,
                          child: Image.network(imageUrl,width: MediaQuery.of(context).size.width*0.3,))
                          : Positioned(
                          top: 10,
                          child: Placeholder(fallbackHeight: 200.0,fallbackWidth: double.infinity)),

                      Positioned(
                          top: MediaQuery.of(context).size.width*0.06,
                          right: 20,
                          height: maxLines * 12.0,
                          left: MediaQuery.of(context).size.width*0.4,
                          child:TextField(
                            maxLines: maxLines,
                            controller: nameController,
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(25),
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Enter Photo Name',
                            ),)
                      ),
                      Positioned(
                          top: maxLines *12.0 + MediaQuery.of(context).size.width*0.1,
                          right: 20,
                          height: maxLines * 12.0,
                          left: MediaQuery.of(context).size.width*0.4,
                          child:TextField(
                            maxLines: maxLines,
                            controller: descriptionController,
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(25),
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Enter Description',
                            ),)
                      ),
                      Positioned(
                        top: maxLines * 24.0 + 60.0,
                        left: MediaQuery.of(context).size.width * 0.15,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: mainTheme,
                              minimumSize: Size(MediaQuery.of(context).size.width * 0.7,50),
                              shape: shape,
                            ),
                            child: new Text(
                              "Upload Photo",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),

                            ),
                            onPressed: () => getImage(),


                          ),
                      ),


                    ],
                  )


              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {

    getNRIC();
  }

  addPhotoToFirestore(String name, String description,String filename,String refurl){

    DateTime now = new DateTime.now();
    photos.add({
      'name': name,
      'description': description,
      'date' : now.toString(),
      'refUrl' : refurl,
      'filename': filename
    });

  }
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

  getImage() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Uploading please wait..."),
    ));
    if (nameController.text.isEmpty || descriptionController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter the name and description"),
      ));
      return;
    }
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();


    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted){
      //Select Image
      image = (await _picker.getImage(source: ImageSource.gallery))!;
      var file = File(image.path);
      var uuid = Uuid();
      String filename = uuid.v1();

      if (image != null){
        //Upload to Firebase
        String name = 'default';
        String description = 'default';
        String refname = widget.refUrl+'/'+filename;
        var snapshot = await _storage.ref()
            .child(refname)
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        print("DOWNLOAD URL");
        print(downloadUrl);
        description = descriptionController.text;
        name = nameController.text;
        addPhotoToFirestore(name,description,downloadUrl,refname);

        print("test");
        Navigator.pop(context);
      } else {
        print('No Path Received');
      }

    } else {
      print('Grant Permissions and try again');
    }

  }

}