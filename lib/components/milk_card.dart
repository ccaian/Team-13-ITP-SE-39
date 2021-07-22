import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growth_app/controllers/forumcontroller.dart';
import 'package:growth_app/milestonepage.dart';
import 'package:growth_app/milkpage.dart';
import 'package:growth_app/model/forum_post.dart';
import 'package:growth_app/model/survey_question.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MilkCard extends StatelessWidget {
  final MilkRecord milkRecord;

  const MilkCard({
    Key? key, required this.milkRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Column(
            children: [
        new Container(
        margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.27,
        child: new Stack(
            children: [
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05,
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05,
                child: Text(
                    milkRecord.weekNo,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    )
                ),
              ),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.08,
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  child: Text(
                      "Left Breast Milk Volume: " + milkRecord.leftBreast +
                          " ml",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[700],
                      )
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.11,
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  child: Text(
                      "Right Breast Milk Volume: " + milkRecord.rightBreast +
                          " ml",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[700],
                      )
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.14,
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  child: Text(
                      "Total Milk Volume: " + milkRecord.totalVolume + " ml",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[700],
                      )
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.14,
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.3,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  child: GestureDetector(
                    onTap: () {
                      updateDialog(context);
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
                ),
              ),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.14,
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.25,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.3,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  child: GestureDetector(
                    onTap: () {
                      _deleteData(context);
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
                ),
              ),
            ]
        ),
        decoration: BoxDecoration(
          color: Color(0xfff2f2f2),
          borderRadius: const BorderRadius.all(
            const Radius.circular(25),
          ),
        )
        )]
    ),);
  }

  void updateDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final _weekNoController = TextEditingController(text: milkRecord.weekNo);
    final _leftBreastController = TextEditingController(text: milkRecord.leftBreast);
    final _rightBreastController = TextEditingController(text: milkRecord.rightBreast);

    String weekNo = '';
    String leftBreast = '';
    String rightBreast = '';
    String totalVolume = '';

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Breast Milk Volume'),
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
                          controller: _weekNoController,
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
                          child: Text("Update"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _updateData(milkRecord.id.toString(), _weekNoController.text, _leftBreastController.text, _rightBreastController.text);
                            }
                            Navigator.pop(context);
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
  }

  void _updateData(String id, String weekNo, String leftBreast, String rightBreast) async {
    var left = double.parse(leftBreast);
    var right = double.parse(rightBreast);
    var totalVolume = (left + right).toString();
    print(id);
    FirebaseFirestore.instance.collection('milk').doc(id).update({
      "weekNo" : weekNo,
      "leftBreast" : leftBreast,
      "rightBreast" : rightBreast,
      "totalVolume" : totalVolume
    }).then((_){
      print("updated!");
    });
  }

  void _deleteData(BuildContext context) {
    var alert = AlertDialog(
        title: Text('Delete Milk Record'),
        content: Text('Are you sure you want to delete?'),
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: secondaryTheme,
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: mainTheme,
              ),
              child: Text('Ok'),
              onPressed: () {
                FirebaseFirestore.instance.collection('milk').doc(milkRecord.id.toString()).delete().then((_) {
                  print("success!");
                });
                Navigator.pop(context);
              }),
        ]);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  //
  // Future<void> _getData() async {
  //   //milk = firestoreInstance.collection('milk').doc(email).collection('records').get(widget.milkRecord.index);
  //   //QuerySnapshot snapshot = await milk.get(widget.milkRecord.index);
  //   //_weekNoController.text = snapsho;
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // setState(() {
  //   //   isAdmin = prefs.getBool('admin')!;
  //   //   if (isAdmin == false) {
  //   //     email = prefs.getString('email');
  //   //   }
  //   //   else {
  //   //     email = prefs.getString('parentemail');
  //   //   }
  //   // });
  //   await Future.delayed(Duration(seconds: 2));
  // }
}