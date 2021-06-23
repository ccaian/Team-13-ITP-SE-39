import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:growth_app/api/firebase_api.dart';

class PhotoDetail extends StatefulWidget {
  @override
  _PhotoDetailState createState() => _PhotoDetailState();
}

class _PhotoDetailState extends State<PhotoDetail> {

  var imageUrl = "https://firebasestorage.googleapis.com/v0/b/growthapplication-77bb4.appspot.com/o/ccaian3%40gmail.com%2FWeek_1%2F1.jpg?alt=media&token=0d8576fe-a68c-47c9-9843-75d58acad217";

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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,0.0),
                            child: new Image(image: new NetworkImage(imageUrl), width: 140.0)
        // child:FutureBuilder<List<FirebaseFile>>(
                          //   future: futureFiles,
                          //   builder: (context, snapshot) {
                          //     switch (snapshot.connectionState) {
                          //       case ConnectionState.waiting:
                          //
                          //         return Center(child: CircularProgressIndicator());
                          //       default:
                          //         if (snapshot.hasError) {
                          //           return Center(child: Text('Some error occurred!'));
                          //         } else {
                          //           final files = snapshot.data!;
                          //
                          //           print(snapshot.data!.length);
                          //           return Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Expanded(
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.fromLTRB(0,0.0,0,0),
                          //                   child: GridView.builder(
                          //                     itemCount: files.length,
                          //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //                       childAspectRatio: 1,
                          //                       crossAxisCount: 2,
                          //                       crossAxisSpacing: 20.0,
                          //                       mainAxisSpacing: 20.0,
                          //                     ),
                          //                     itemBuilder: (context, index) {
                          //
                          //                       final file = files[index];
                          //                       return buildFile(context, file, index);
                          //                     },
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           );
                          //         }
                          //     }
                          //   },
                          // ),

                        )
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