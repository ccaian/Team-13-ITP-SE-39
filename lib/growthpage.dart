import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growth_app/addmeasurements.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/pdf_api.dart';
import 'api/pdf_growth_api.dart';

class GrowthPage extends StatefulWidget {
  @override
  _GrowthPageState createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {
  late Query _growthRef;
  late Growth growthFile;

  List<DataRow> growthList = [];
  List<GrowthItem> growthItems = [];

  var nric;
  var name;
  var date;
  var weight;
  var height;
  var head;

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
                  child: Text("Baby Name",
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
                              15.0, 30.0, 0.0, 0.0),
                          child: SingleChildScrollView (
                              child: DataTable(
                                columnSpacing: 45.0,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'Date',
                                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Weight',
                                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Height',
                                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Head',
                                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: growthList,
                              )
                          )
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
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
                  child: Icon(Icons.download),
                  backgroundColor: Color(0xff4C52A8),
                  onPressed: () async {
                    growthFile = Growth(items: growthItems);
                    final pdfFile = await PdfGrowthApi.generate(growthFile);
                    PdfApi.openFile(pdfFile);
                  },
                ),
              ),
            ],
          ),
        ));
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
                      Text(values['height'] + " kg"),
                    ),
                    DataCell(
                      Text(values['head'] + " cm"),
                    ),
                  ]
              )
          );
          items.add(
            GrowthItem(
              date: values['date'],
              weight: values['weight'],
              height: values['height'],
              head: values['head'],
            )
          );
        });
        setState(() {
          growthList = rows;
          growthItems = items;
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
  final String date;
  final String weight;
  final String height;
  final String head;

  const GrowthItem({
    required this.date,
    required this.weight,
    required this.height,
    required this.head,
  });
}
