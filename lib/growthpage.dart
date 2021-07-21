import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/addmeasurements.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/pdf_api.dart';
import 'api/pdf_growth_api.dart';
import 'editmeasurements.dart';

class GrowthPage extends StatefulWidget {
  @override
  _GrowthPageState createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {
  late Query _growthRef;
  late Growth growthFile;
  DatabaseReference reference = FirebaseDatabase.instance.reference().child('growth');

  List<DataRow> growthList = [];
  List<GrowthItem> growthItems = [];

  var nric;
  var week;
  //var date;
  var weight;
  var height;
  var head;
  var growthKey;

  String? childName = "";

  @override
  List<DataRow> get rows => growthList;

  @override
  void initState() {
    super.initState();
    _growthRef = FirebaseDatabase.instance.reference().child('growth');
    retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
          color: Color(0xff4C52A8),
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 80,
                  left: 30,
                  child: Text("Growth Parameter \nFor Child",
                      //childName.toString()
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ))),
              Positioned(
                top: 40,
                right: -10,
                child: new Image.asset('assets/milkbottle.png', width: 140.0),
              ),
              Positioned(
                top: 190,
                bottom: 0,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      //const SizedBox(height: 100),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(
                              0.0, 30.0, 0.0, 0.0),
                          child: FirebaseAnimatedList(
                              query: _growthRef,
                              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                                Map growth = snapshot.value;
                                growth['key'] = snapshot.key;
                                return _buildGrowthItem(growth: growth);
                              }
                          )
                          // child: SingleChildScrollView (
                          //     child: DataTable(
                          //       showCheckboxColumn: false,
                          //       columnSpacing: 40.0,
                          //       columns: const <DataColumn>[
                          //         DataColumn(
                          //           label: Text(
                          //             'Date',
                          //             style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                          //           ),
                          //         ),
                          //         DataColumn(
                          //           label: Text(
                          //             'Weight',
                          //             style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                          //           ),
                          //         ),
                          //         DataColumn(
                          //           label: Text(
                          //             'Height',
                          //             style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                          //           ),
                          //         ),
                          //         DataColumn(
                          //           label: Text(
                          //             'Head',
                          //             style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                          //           ),
                          //         ),
                          //       ],
                          //       rows: growthList,
                          //     )
                          // )
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  heroTag: "add",
                  child: Icon(Icons.add),
                  backgroundColor: Color(0xff4C52A8),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => AddMeasurements()));
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                right: 90,
                child: FloatingActionButton(
                  heroTag: "download",
                  child: Icon(Icons.download),
                  backgroundColor: Color(0xff4C52A8),
                  onPressed: () async {
                    //growthFile = Growth(items: growthItems);
                    growthFile = Growth(items: [
                      GrowthItem(
                        key: nric,
                        week: 'Week 1',
                        weight: '10',
                        height: '20',
                        head: '30',
                      ),
                      GrowthItem(
                        key: nric,
                        week: 'Week 2',
                        weight: '15',
                        height: '25',
                        head: '35',
                      ),
                      GrowthItem(
                        key: nric,
                        week: 'Week 1',
                        weight: '20',
                        height: '30',
                        head: '40',
                      ),
                    ]);
                    final pdfFile = await PdfGrowthApi.generate(growthFile);
                    PdfApi.openFile(pdfFile);
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildGrowthItem({required Map growth}) {
    return Container(
      margin: EdgeInsets.symmetric(),
      padding: EdgeInsets.all(10),
      height: 120,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 30),
              Text(
                growth['week'],
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
              children: [
                SizedBox(width: 30),
                Text(
                  "Weight: " + growth['weight'] + "kg, ",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black),
                ),
                Text(
                  "Height: " + growth['height'] + "cm, ",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black),
                ),
                Text(
                  "Head: " + growth['head'] + "cm",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black),
                ),
              ]
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditMeasurements(
                            growthKey: growth['key'],
                          )));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Edit',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  _showDeleteDialog(growth: growth);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Delete',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[700],
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _showDeleteDialog({required Map growth}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Measurement'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    reference
                        .child(growth['key'])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  Future<void> retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nric = prefs.getString('ChildNRIC');

    Query _growthQuery = _growthRef.orderByChild('nric').equalTo(nric);
    List<DataRow> rows = [];
    List<GrowthItem> items = [];

    await _growthQuery.once().then((DataSnapshot snapShot) {

      if (snapShot.value != null) {
        Map<dynamic, dynamic> values = snapShot.value;
        values.forEach((key, values) {
          growthKey = key;
          rows.add(
              DataRow(
                  cells: [
                    DataCell(
                      Text(values['date']),
                    ),
                    DataCell(
                      Text(values['weight'] + " kg"),
                    ),
                    DataCell(
                      Text(values['height'] + " cm"),
                    ),
                    DataCell(
                      Text(values['head'] + " cm"),
                    ),
                  ],
                      onSelectChanged: (val) {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => EditMeasurements(
                                  growthKey: key,
                                )));
                      },
              )
          );
          items.add(
            GrowthItem(
              key: key,
              week: values['week'],
              //date: values['date'],
              weight: values['weight'],
              height: values['height'],
              head: values['head'],
            ),
          );
          setState(() {
            print(growthKey);
            growthList = rows;
            growthItems = items;
            childName = prefs.getString('ChildName');
          });
        });
      }
    });
  }
}

class Growth {
  final List<GrowthItem> items;

  Growth({required this.items});
}

class GrowthItem {
  final String key;
  final String week;
  //final String date;
  final String weight;
  final String height;
  final String head;

  const GrowthItem({
    required this.key,
    required this.week,
    //required this.date,
    required this.weight,
    required this.height,
    required this.head,
  });
}
