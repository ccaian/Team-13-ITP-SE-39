import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:growth_app/api/firebase_api.dart';

class PhotoDetail extends StatefulWidget {

  final String url;
  const PhotoDetail({
    Key? key,
    required this.url,
  }) : super(key: key);


  @override
  _PhotoDetailState createState() => _PhotoDetailState();
}

class _PhotoDetailState extends State<PhotoDetail> {

  FirebaseAuth auth = FirebaseAuth.instance;

  late String imageUrl = "";
  late String user = "Miranda";
  @override
  void initState() {
    imageUrl = widget.url;
  }

  @override
  Widget build(BuildContext context) {
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
                    "Photo Detail",
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
                        child: Stack(
                          children: <Widget>[

                            new Text(user)
                            ,
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,0.0),
                                child: new Image(image: new NetworkImage(imageUrl), width: 140.0)
                            ),

                          ])
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: FloatingActionButton(
                        // isExtended: true,
                        child: Icon(Icons.download),
                        backgroundColor: Color(0xff4C52A8),
                        onPressed: () async {
                          // Navigator.push(context, new MaterialPageRoute(
                          //     builder: (context) => UploadPhoto(refUrl: widget.refUrl)
                          // ));
                          try {
                            // Saved with this method.
                            var imageId =
                            await ImageDownloader.downloadImage(imageUrl);
                            if (imageId == null) {
                            return;
                            }
                            // Below is a method of obtaining saved image information.
                            var fileName = await ImageDownloader.findName(imageId);
                            var path = await ImageDownloader.findPath(imageId);
                            var size = await ImageDownloader.findByteSize(imageId);
                            var mimeType = await ImageDownloader.findMimeType(imageId);
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Image has been downloaded to your device.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            } on PlatformException catch (error) {
                            print(error);
                            }
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

}