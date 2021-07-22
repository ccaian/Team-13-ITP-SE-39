import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/milk_card.dart';


class MilkPage extends StatefulWidget {

  @override
  _MilkPageState createState() => _MilkPageState();
}

class _MilkPageState extends State<MilkPage> {

  final _formKey = GlobalKey<FormState>();
  late CollectionReference milk, records;

  bool isAdmin = false;
  var email;
  String weekNo = '';
  String leftBreast = '';
  String rightBreast = '';
  String totalVolume = '';

  // double leftBreast = 0;
  // double rightBreast = 0;
  // double totalVolume = 0;

  final firestoreInstance = FirebaseFirestore.instance;
  final _weekNoController = TextEditingController();
  final _leftBreastController = TextEditingController();
  final _rightBreastController = TextEditingController();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //records = firestoreInstance.collection('milk').doc(email).collection('records');
    records = firestoreInstance.collection('milk');
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
                  "Milk Volume\nRecord",
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
                  stream: records.orderBy('weekNo', descending: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    // if (!snapshot.hasData) return new Center(
                    //   child: Text(
                    //     "There is no data",
                    //     textAlign: TextAlign.center,
                    //   ),
                    // );
                    if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                    List milkList = snapshot.data!.docs;
                    List<MilkRecord> _records = milkList.map(
                          (milk) => MilkRecord(
                            id: milk.id,
                            weekNo: milk['weekNo'],
                            leftBreast: milk['leftBreast'],
                            rightBreast: milk['rightBreast'],
                            totalVolume: milk['totalVolume'],
                          ),
                    ).toList();
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index){
                        return MilkCard(
                            milkRecord: _records[index],
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
                        title: const Text('Enter Breast Milk Volume'),
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
                                        labelText: 'Week #',
                                      ),
                                      validator: (val) => val!.isEmpty ? 'Enter week' : null,
                                      onChanged: (val) {
                                        setState(() => weekNo = val);
                                      },
                                      controller: _weekNoController..text = 'Week ',
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
                                        labelText: 'Left Breast Milk Volume (ml)',
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                                      ],
                                      validator: (val) => val!.isEmpty ? 'Enter left breast milk volume in ml' : null,
                                      onChanged: (val) {
                                        setState(() => leftBreast = val);
                                      },
                                      controller: _leftBreastController,
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
                                        labelText: 'Right Breast Milk Volume (ml)',
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                                      ],
                                      validator: (val) => val!.isEmpty ? 'Enter right breast milk volume in ml' : null,
                                      onChanged: (val) {
                                        setState(() => rightBreast = val);
                                      },
                                      controller: _rightBreastController,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.deepPurple,
                                        minimumSize: Size(200,50),
                                        //shape: shape,
                                      ),
                                      child: Text("Submit"),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _addData();
                                        }
                                      },
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
        ],
      ),
    );
  }

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

  void _addData() async{
    //milk = firestoreInstance.collection('milk').doc(email).collection('records');
    milk = firestoreInstance.collection('milk');

    var left = double.parse(_leftBreastController.text);
    var right = double.parse(_rightBreastController.text);
    totalVolume = (left + right).toString();

    milk.add(
        {
          "weekNo" : _weekNoController.text,
          "leftBreast" : _leftBreastController.text,
          "rightBreast" : _rightBreastController.text,
          "totalVolume" : totalVolume
        }).then((_){
      print("success!");
    });
    Navigator.pop(context);
    setState(() {
      _leftBreastController.clear();
      _rightBreastController.clear();
    });
  }
}

class MilkRecord {
  final String? id;
  final String weekNo;
  final String leftBreast;
  final String rightBreast;
  final String totalVolume;

  MilkRecord({this.id, required this.weekNo, required this.leftBreast,required this.rightBreast, required this.totalVolume});
}
