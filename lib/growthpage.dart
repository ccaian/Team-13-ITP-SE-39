import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/model/fenton_chart_data.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/pdf_api.dart';
import 'api/pdf_growth_api.dart';
import 'components/growth_card.dart';
import 'fentonchart.dart';

class GrowthPage extends StatefulWidget {
  @override
  _GrowthPageState createState() => _GrowthPageState();
}

///  Growth Page State for adding, displaying, and downloading growth data
class _GrowthPageState extends State<GrowthPage> {
  final _formKey = GlobalKey<FormState>();

  bool isAdmin = false;
  var nric, childName;
  String gender = '';
  String week = '';
  String weight = '';
  String height = '';
  String head = '';

  TextEditingController _weekControl = TextEditingController();
  TextEditingController _weightControl = TextEditingController();
  TextEditingController _heightControl = TextEditingController();
  TextEditingController _headControl = TextEditingController();

  final firestoreInstance = FirebaseFirestore.instance;
  late CollectionReference growth, records, check;

  late Growth growthFile;
  List<GrowthRecord> growthRecords = [];

  var weekNo = 1;
  var weekVal = '0';

  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    records =
        firestoreInstance.collection('growth').doc(nric).collection('records');

    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: mainTheme,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 80,
                  left: 30,
                  child: Text("Growth\nMeasurements",
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
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: StreamBuilder(
                            stream: records
                                .orderBy('week', descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                    child: CircularProgressIndicator());
                              List growthList = snapshot.data!.docs;
                              List<GrowthRecord> _records = growthList
                                  .map(
                                    (growth) => GrowthRecord(
                                      id: growth.id,
                                      week: growth['week'],
                                      weight: growth['weight'],
                                      height: growth['height'],
                                      head: growth['head'],
                                    ),
                                  )
                                  .toList();
                              return ListView.builder(
                                itemCount: snapshot.data!.size,
                                itemBuilder: (context, index) {
                                  return GrowthCard(
                                    growthRecord: _records[index],
                                    isAdmin: isAdmin,
                                    nric: nric,
                                  );
                                },
                              );
                            },
                          ))
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
                  backgroundColor: mainTheme,
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Add Growth Measurements'),
                            content: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(25),
                                                ),
                                              ),
                                              fillColor: Colors.red,
                                              labelText: 'Week No',
                                              hintText: 'e.g. 1',
                                            ),
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return ('Enter week number');
                                              } else if (int.parse(val) < 1) {
                                                return ('Value cannot be less than 1.');
                                              } else if (int.parse(val) >= 50) {
                                                return ('Value cannot be more than 50.');
                                              }
                                            },
                                            onChanged: (val) {
                                              setState(() => week = val);
                                            },
                                            controller: _weekControl
                                              ..text = weekNo.toString(),
                                            enabled: false,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(25),
                                                ),
                                              ),
                                              fillColor: Colors.red,
                                              labelText: 'Weight (g)',
                                              hintText: 'e.g. 200',
                                            ),
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9.]")),
                                            ],
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return ('Enter weight in g');
                                              } else if (double.parse(val) <=
                                                  100) {
                                                return ('Value cannot be less than 100g.');
                                              } else if (double.parse(val) >=
                                                  2000) {
                                                return ('Value cannot be more than 2000g.');
                                              }
                                            },
                                            onChanged: (val) {
                                              setState(() => weight = val);
                                            },
                                            controller: _weightControl,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(25),
                                                ),
                                              ),
                                              fillColor: Colors.red,
                                              labelText: 'Height/Length (cm)',
                                              hintText: 'e.g. 2',
                                            ),
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9.]")),
                                            ],
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return ('Enter height/length in cm');
                                              } else if (double.parse(val) <=
                                                  1) {
                                                return ('Value cannot be less than 1cm.');
                                              } else if (double.parse(val) >=
                                                  1000) {
                                                return ('Value cannot be more than 1000cm.');
                                              }
                                            },
                                            onChanged: (val) {
                                              setState(() => height = val);
                                            },
                                            controller: _heightControl,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(25),
                                                ),
                                              ),
                                              fillColor: Colors.red,
                                              labelText:
                                                  'Head Circumference (cm)',
                                              hintText: 'e.g. 2',
                                            ),
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9.]")),
                                            ],
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return ('Enter head circumference in cm');
                                              } else if (double.parse(val) <=
                                                  1) {
                                                return ('Value cannot be less than 1cm.');
                                              } else if (double.parse(val) >=
                                                  50) {
                                                return ('Value cannot be more than 50cm.');
                                              }
                                            },
                                            onChanged: (val) {
                                              setState(() => head = val);
                                            },
                                            controller: _headControl,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: secondaryTheme,
                                                    ),
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                SizedBox(width: 20),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: mainTheme,
                                                  ),
                                                  child: Text("Submit"),
                                                  onPressed: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _addData();
                                                    }
                                                  },
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                right: 90,
                child: FloatingActionButton(
                  heroTag: "download",
                  child: Icon(Icons.download),
                  backgroundColor: mainTheme,
                  onPressed: () async {
                    _downloadData();
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                right: 160,
                child: FloatingActionButton(
                  heroTag: "chart",
                  child: Icon(Icons.bar_chart),
                  backgroundColor: secondaryTheme,
                  onPressed: () async {
                    _generateChart();
                  },
                ),
              ),
            ],
          ),
        ));
  }

  /// Function for getting week number
  Future<void> _getWeek() async {
    growth =
        firestoreInstance.collection('growth').doc(nric).collection('records');

    final QuerySnapshot result =
        await growth.orderBy('week', descending: true).limit(1).get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isNotEmpty) {
      documents.forEach((element) {
        weekVal = element['week'];
        weekNo = int.parse(weekVal) + 1;
      });
    }
  }

  /// Function for getting shared preferences data
  Future<void> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nric = prefs.getString('ChildNRIC');
      isAdmin = prefs.getBool('admin')!;
      childName = prefs.getString('ChildName');
      // gender = prefs.getString('gender');
      _getWeek();
    });
    await Future.delayed(Duration(seconds: 2));
  }

  /// Function for creating Growth record in Firestore
  ///
  /// Function will use [week], [weight], [height], and [head] params to create a Growth record
  void _addData() async {
    growth =
        firestoreInstance.collection('growth').doc(nric).collection('records');

    final QuerySnapshot result =
        await growth.where('week', isEqualTo: _weekControl.text).limit(1).get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Record already exists"),
            content: new Text("Only one entry per week allowed!"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: mainTheme,
                  ),
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        },
      );
    } else {
      growth.add({
        "week": _weekControl.text,
        "weight": _weightControl.text,
        "height": _heightControl.text,
        "head": _headControl.text
      });
      Navigator.pop(context);
      setState(() {
        _weekControl.clear();
        _weightControl.clear();
        _heightControl.clear();
        _headControl.clear();
        _getWeek();
      });
    }
  }

  /// Function for downloading Growth records PDF file
  Future<void> _downloadData() async {
    var getDocs = await FirebaseFirestore.instance
        .collection('growth')
        .doc(nric)
        .collection('records')
        .orderBy('week')
        .get();

    List growthList = getDocs.docs;
    List<GrowthRecord> _records = growthList
        .map(
          (growth) => GrowthRecord(
            id: growth.id,
            week: growth['week'],
            weight: growth['weight'],
            height: growth['height'],
            head: growth['head'],
          ),
        )
        .toList();

    growthFile = Growth(items: _records, name: childName);
    final pdfFile = await PdfGrowthApi.generate(growthFile);
    PdfApi.openFile(pdfFile);
  }

  /// Function for downloading Growth records PDF file
  Future<void> _generateChart() async {
    var getDocs = await FirebaseFirestore.instance
        .collection('growth')
        .doc(nric)
        .collection('records')
        .orderBy('week')
        .get();

    List growthList = getDocs.docs;
    List<WeightChart> _weightArray = [];
    List<HeightChart> _heightArray = [];
    List<HeadChart> _headArray = [];

    growthList.forEach((element) {
      print(int.parse(element['week']).runtimeType);
      if (int.parse(element['week']) >= 0) {
        int weekNo = int.parse(element['week']);

        _weightArray.add(WeightChart(
            weekNumber: weekNo, weightData: double.parse(element['weight'])));
        _headArray.add(
            HeadChart(weekNumber: weekNo, headData: double.parse(element['head'])));
        _heightArray.add(HeightChart(
            weekNumber: weekNo, heightData: double.parse(element['height'])));
      }
    });
    print(_headArray);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FentonChart(
                weightArray: _weightArray,
                heightArray: _heightArray,
                headArray: _headArray,
                gender: 'male', // TO BE CHANGED, LINUS TO STORE GENDER TO SHAREDPREFERENCE.
            )));
    print(_weightArray);
    print(_heightArray);
    print(_headArray);
  }
}

class GrowthRecord {
  final String? id;
  final String week;
  final String weight;
  final String height;
  final String head;

  GrowthRecord(
      {this.id,
      required this.week,
      required this.weight,
      required this.height,
      required this.head});
}

class Growth {
  final List<GrowthRecord> items;
  final String name;

  Growth({required this.items, required this.name});
}
