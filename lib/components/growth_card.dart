import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../growthpage.dart';

/// GrowthCard exist to populate the data retrieved from Firestore
/// for visualisation on the UI with Update and Delete functions for each data
class GrowthCard extends StatelessWidget {
  /// [growthRecord] to parse the data for each card for visualisation on the UI
  /// [isAdmin] parse to identify if this user has admin access or not
  /// [nric] parse to get baby's identification number
  const GrowthCard({
    Key? key,
    required this.growthRecord,
    required this.isAdmin,
    required this.nric,
  }) : super(key: key);

  final GrowthRecord growthRecord;
  final isAdmin;
  final nric;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(children: [
        new Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.27,
            child: new Stack(children: [
              Positioned(
                top: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Text("Week " + growthRecord.week,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    )),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.10,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text("Weight: " + growthRecord.weight + " g",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[700],
                      )),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.13,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text("Height/Length: " + growthRecord.height + " cm",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[700],
                      )),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.16,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child:
                      Text("Head Circumference: " + growthRecord.head + " cm",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[700],
                          )),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
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
                top: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width * 0.25,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: GestureDetector(
                    onTap: () {
                      if (isAdmin == false) {
                        _deleteData(context);
                      } else if (isAdmin == true) {
                        _adminDelete(context);
                      }
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
            ]),
            decoration: BoxDecoration(
              color: Color(0xfff2f2f2),
              borderRadius: const BorderRadius.all(
                const Radius.circular(25),
              ),
            ))
      ]),
    );
  }

  /// Update Dialog for Growth Measurements Data.
  ///
  /// Has [key], [week], [height], [weight], and [head] fields to parse param to update function.
  void updateDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final _weekControl = TextEditingController(text: growthRecord.week);
    final _weightControl = TextEditingController(text: growthRecord.weight);
    final _heightControl = TextEditingController(text: growthRecord.height);
    final _headControl = TextEditingController(text: growthRecord.head);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Growth Measurements'),
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                          Column(
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
                                labelText: 'Week No',
                                hintText: 'e.g. 1',
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
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
                              controller: _weekControl,
                              enabled: false,
                              style: TextStyle(color: Colors.grey),
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
                                labelText: 'Weight (g)',
                                hintText: 'e.g. 200',
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                              ],
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return ('Enter weight in gram (g)');
                                } else if (double.parse(val) <= 100) {
                                  return ('Value cannot be less than 100g.');
                                } else if (double.parse(val) >= 2000) {
                                  return ('Value cannot be more than 2000g.');
                                }
                              },
                              controller: _weightControl,
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
                                labelText: 'Height/Length (cm)',
                                hintText: 'e.g. 2',
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                              ],
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return ('Enter height/length in cm');
                                } else if (double.parse(val) <= 1) {
                                  return ('Value cannot be less than 1cm.');
                                } else if (double.parse(val) >= 1000) {
                                  return ('Value cannot be more than 1000cm.');
                                }
                              },
                              controller: _heightControl,
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
                                labelText: 'Head Circumference (cm)',
                                hintText: 'e.g. 2',
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                              ],
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return ('Enter head circumference in cm');
                                } else if (double.parse(val) <= 1) {
                                  return ('Value cannot be less than 1cm.');
                                } else if (double.parse(val) >= 50) {
                                  return ('Value cannot be more than 50cm.');
                                }
                              },
                              controller: _headControl,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
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
                                      child: Text("Update"),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _updateData(
                                              growthRecord.id.toString(),
                                              _weekControl.text,
                                              _weightControl.text,
                                              _heightControl.text,
                                              _headControl.text);
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ])),
                        ],
                      )
                    ],
                  ),
                ),
              )],
            ),
          );
        });
  }

  /// Dialog to confirm the deletion of Growth Measurements Data. [Parent]
  void _deleteData(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Delete Growth Measurements'),
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
                      FirebaseFirestore.instance
                          .collection('growth')
                          .doc(nric)
                          .collection('records')
                          .doc(growthRecord.id.toString())
                          .delete();
                      Navigator.pop(context);
                    }),
              ]);
        });
  }

  /// Dialog to confirm the deletion of Growth Measurements Data. [Admin]
  ///
  /// Dialog with a Form to accept Admin Pin for confirmation of deletion.
  void _adminDelete(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    final _pinController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Delete Growth Measurements'),
              content: Text('Are you sure you want to delete?'),
              actions: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 10.0, 20.0),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(25),
                                    ),
                                  ),
                                  fillColor: secondaryTheme,
                                  labelText: 'Admin PIN',
                                ),
                                validator: (val) => val!.isEmpty
                                    ? 'Enter your Admin PIN'
                                    : null,
                                controller: _pinController,
                              )),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: secondaryTheme,
                                    ),
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                SizedBox(width: 20),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: mainTheme,
                                    ),
                                    child: Text('Delete'),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _verifyPIN(growthRecord.id.toString(),
                                            _pinController.text, context);
                                      }
                                    }),
                              ])
                        ]))
              ]);
        });
  }

  /// Update Growth Measurements Data.
  ///
  /// Params [key], [week], [weight], [height], and [head] to update the database.
  void _updateData(String id, String week, String weight, String height, String head) async {
    FirebaseFirestore.instance
        .collection('growth')
        .doc(nric)
        .collection('records')
        .doc(id)
        .update({
      "week": week,
      "weight": weight,
      "height": height,
      "head": head,
    });
  }

  /// Delete Growth Measurements Data. [Admin]
  ///
  /// Accepts [key] : to delete the correct data,
  /// [pin] : to verify with the admin pin stored in SharedPreferences
  /// and [context] : for dismissing of dialog box, to update the database.
  void _verifyPIN(String key, String pin, BuildContext context) async {
    /// Retrieve hashed adminPin stored in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var adminPin = prefs.getString('adminPin').toString();

    /// Convert and hash the entered pin by user for matching with pin in SharedPreferences
    var pinBytes = utf8.encode(pin);
    var hashedPin = sha256.convert(pinBytes).toString();

    /// If the hashed pin in SharedPreferences matches the hashed pin input, delete record
    /// If the hashed pin in SharedPreferences does not match the hashed pin input, prompt error message
    if (adminPin == hashedPin) {
      FirebaseFirestore.instance
          .collection('growth')
          .doc(nric)
          .collection('records')
          .doc(key)
          .delete();
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
          msg: "Invalid Admin PIN",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
