import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/pdf_api.dart';
import 'api/pdf_milk_api.dart';
import 'components/milk_card.dart';


class MilkPage extends StatefulWidget {
  @override
  _MilkPageState createState() => _MilkPageState();
}

///  Milk Page State for adding, displaying, and downloading milk data
class _MilkPageState extends State<MilkPage> {
  final _formKey = GlobalKey<FormState>();
  late CollectionReference milk, records;

  bool isAdmin = false;
  var email;
  String title = '';
  String leftBreast = '';
  String rightBreast = '';
  String totalVolume = '';
  DateTime now = DateTime.now();

  final firestoreInstance = FirebaseFirestore.instance;
  final _titleController = TextEditingController();
  final _leftBreastController = TextEditingController();
  final _rightBreastController = TextEditingController();

  late Milk milkFile;
  List<MilkRecord> milkRecords = [];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    records = firestoreInstance.collection('milk').doc(email).collection('records');

    return Container(
      color: mainTheme,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 80,
              left: 30,
              child: Text(
                  "Milk Volume\nPumped",
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
                child: StreamBuilder (
                  stream: records.orderBy('timestamp', descending: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                    List milkList = snapshot.data!.docs;
                    List<MilkRecord> _records = milkList.map(
                          (milk) => MilkRecord(
                            id: milk.id,
                            title: milk['title'],
                            leftBreast: milk['leftBreast'],
                            rightBreast: milk['rightBreast'],
                            totalVolume: milk['totalVolume'],
                            timestamp: milk['timestamp'].toDate(),
                          ),
                    ).toList();
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index){
                        return MilkCard(
                          milkRecord: _records[index],
                          isAdmin: isAdmin,
                          email: email,
                        );
                      },
                    );
                  },
              )
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
                        title: const Text('Add Milk Volume Pumped'),
                        content: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(25),
                                          ),
                                        ),
                                        fillColor: Colors.red,
                                        labelText: 'Title',
                                      ),
                                      validator: (val) => val!.isEmpty ? 'Enter any title' : null,
                                      onChanged: (val) {
                                        setState(() => title = val);
                                      },
                                      controller: _titleController,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(25),
                                          ),
                                        ),
                                        fillColor: Colors.red,
                                        labelText: 'Left Volume Pumped (ml)',
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                                      ],
                                      validator: (val) => val!.isEmpty ? 'Enter left volume pumped in ml' : null,
                                      onChanged: (val) {
                                        setState(() => leftBreast = val);
                                      },
                                      controller: _leftBreastController..text = '0',
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(25),
                                          ),
                                        ),
                                        fillColor: Colors.red,
                                        labelText: 'Right Volume Pumped (ml)',
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                                      ],
                                      validator: (val) => val!.isEmpty ? 'Enter right volume pumped in ml' : null,
                                      onChanged: (val) {
                                        setState(() => rightBreast = val);
                                      },
                                      controller: _rightBreastController..text = '0',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row (
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: secondaryTheme,
                                              ),
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                          SizedBox(width: 20),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: mainTheme,
                                            ),
                                            child: Text("Submit"),
                                            onPressed: () async {
                                              if (_formKey.currentState!.validate()) {
                                                _addData();
                                              }
                                            },
                                          ),
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
        ],
      ),
    );
  }

  /// Function for getting shared preferences data
  Future<void> _getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = prefs.getBool('admin')!;

      if (isAdmin == false) {
        email = prefs.getString('email');
      }
      else {
        email = prefs.getString('parentemail');
      }
    });
    await Future.delayed(Duration(seconds: 2));
  }

  /// Function for creating Milk record in Firestore
  ///
  /// Function will use [title], [leftBreast], [rightBreast], [totalVolume], and [timestamp] params to create a Milk record
  void _addData() async{
    milk = firestoreInstance.collection('milk').doc(email).collection('records');

    var left = double.parse(_leftBreastController.text);
    var right = double.parse(_rightBreastController.text);
    totalVolume = (left + right).toString();

    milk.add(
        {
          "title" : _titleController.text,
          "leftBreast" : _leftBreastController.text,
          "rightBreast" : _rightBreastController.text,
          "totalVolume" : totalVolume,
          "timestamp" : now,
        });
    Navigator.pop(context);
    setState(() {
      _titleController.clear();
      _leftBreastController.clear();
      _rightBreastController.clear();
    });
  }

  /// Function for downloading Milk records PDF file
  Future<void> _downloadData() async {
    var getDocs = await FirebaseFirestore.instance.collection('milk').doc(email).collection('records').get();

    List milkList = getDocs.docs;
    List<MilkRecord> _records = milkList.map(
          (milk) => MilkRecord(
        id: milk.id,
        title: milk['title'],
        leftBreast: milk['leftBreast'],
        rightBreast: milk['rightBreast'],
        totalVolume: milk['totalVolume'],
        timestamp: milk['timestamp'].toDate(),
      ),
    ).toList();
    milkFile = Milk(items: _records);
    final pdfFile = await PdfMilkApi.generate(milkFile);
    PdfApi.openFile(pdfFile);
  }
}

class MilkRecord {
  final String? id;
  final String title;
  final String leftBreast;
  final String rightBreast;
  final String totalVolume;
  final DateTime timestamp;

  MilkRecord({this.id, required this.title, required this.leftBreast,required this.rightBreast, required this.totalVolume, required this.timestamp});
}

class Milk {
  final List<MilkRecord> items;

  Milk({required this.items});
}
