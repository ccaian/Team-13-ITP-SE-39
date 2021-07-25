import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';



class MilestoneGuidance extends StatefulWidget {


  @override
  _MilestoneGuidanceState createState() => _MilestoneGuidanceState();
}

class _MilestoneGuidanceState extends State<MilestoneGuidance> {
  late Query _ref;
  //final firebaseDB = FirebaseDatabase.instance.reference().child('milestones');
  @override
  void initState(){
    super.initState();
    _ref = FirebaseDatabase.instance.reference().child('milestones');

  }
  @override
  Widget build(BuildContext context) {
    var chapterlist = ['Welcome Address',
      'Orientation to the Neonatal ICU',
      'First days of life ',
      'Breastfeeding ',
      'First week of life',
      'First 1-2 months of life',
      'Your baby is now full term! ',
      'Developmental milestones & guide'];
    final numOfChapters = 8;
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
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
              child: new Container(
                child: new ListView(
                  scrollDirection: Axis.vertical,
                  children: new List.generate(numOfChapters, (int index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,20.0),
                      child: InkWell(
                        onTap: () {
                          String name = 'chapter'+(index+1).toString();
                          print("test");
                          downloadURLExample(name);
                        },
                        child: new Container(

                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: new Stack(
                            children: [
                              Positioned(
                                top: MediaQuery.of(context).size.width * 0.05,
                                left: MediaQuery.of(context).size.width * 0.05,
                                child: Text(
                                    "Chapter "+(index+1).toString(),
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    )
                                ),

                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.width * 0.13,
                                left: MediaQuery.of(context).size.width * 0.05,
                                child: Text(
                                    chapterlist[index],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[500],
                                    )
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
                    );
                  }),
                ),
              ),
            ),

          ]
        )
      ),
    );
  }
  Future<void> downloadURLExample(String url) async {

    print('milestones/'+url);
    String downloadURL = await FirebaseStorage.instance
        .ref('milestones/'+url+'.pdf')
        .getDownloadURL();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    Dio dio = Dio();

    print(downloadURL);
    // Within your widgets:
    // Image.network(downloadURL);
  }


}
