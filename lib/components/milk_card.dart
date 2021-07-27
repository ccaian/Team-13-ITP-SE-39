import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/milkpage.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// MilkCard exist to populate the data retrieved from Firestore
/// for visualisation on the UI with Update and Delete functions for each data
class MilkCard extends StatelessWidget {
  /// [milkRecord] to parse the data for each card for visualisation on the UI
  /// [isAdmin] parse to identify if this user has admin access or not
  /// [email] parse to get parent's email address
  const MilkCard({
    Key? key,
    required this.milkRecord,
    required this.isAdmin,
    required this.email,
  }) : super(key: key);

  final MilkRecord milkRecord;
  final isAdmin;
  final email;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(children: [
        new Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.22,
            child: new Stack(children: [
              Positioned(
                top: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Text(milkRecord.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    )),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.06,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(milkRecord.timestamp.toString(),
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[700],
                      )),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.11,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                      "Total Milk Volume: " + milkRecord.totalVolume + " ml",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[700],
                      )),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.11,
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
                top: MediaQuery.of(context).size.height * 0.11,
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

  /// Update Dialog for Milk Volume Pumped Data.
  ///
  /// Has [key], [title], [leftBreast], and [rightBreast] fields to parse param to update function.
  void updateDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final _titleController = TextEditingController(text: milkRecord.title);
    final _leftBreastController =
        TextEditingController(text: milkRecord.leftBreast);
    final _rightBreastController =
        TextEditingController(text: milkRecord.rightBreast);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Milk Volume Pumped'),
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
                          validator: (val) =>
                              val!.isEmpty ? 'Enter title' : null,
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
                          validator: (val) {
                            if (val!.isEmpty) {
                              return ('Enter left volume pumped in ml');
                            }
                            else if (double.parse(val) <= 0.1) {
                              return ('Value cannot be less than 0.1ml.');
                            }
                            else if (double.parse(val) >= 5000) {
                              return ('Value cannot be more than 5l.');
                            }
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
                            labelText: 'Right Volume Pumped (ml)',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                          ],
                          validator: (val) {
                            if (val!.isEmpty) {
                              return ('Enter right volume pumped in ml');
                            }
                            else if (double.parse(val) <= 0.1) {
                              return ('Value cannot be less than 0.1ml.');
                            }
                            else if (double.parse(val) >= 5000) {
                              return ('Value cannot be more than 5l.');
                            }
                          },
                          controller: _rightBreastController,
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
                                          milkRecord.id.toString(),
                                          _titleController.text,
                                          _leftBreastController.text,
                                          _rightBreastController.text);
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ])),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  /// Dialog to confirm the deletion of Milk Volume Pumped Data. [Parent]
  void _deleteData(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
                      FirebaseFirestore.instance
                          .collection('milk')
                          .doc(email)
                          .collection('records')
                          .doc(milkRecord.id.toString())
                          .delete()
                          .then((_) {});
                      Navigator.pop(context);
                    }),
              ]);
        });
  }

  /// Dialog to confirm the deletion of Milk Volume Pumped Data. [Admin]
  ///
  /// Dialog with a Form to accept Admin Pin for confirmation of deletion.
  void _adminDelete(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    final _pinController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Delete Milk Record'),
              content: Text('Are you sure you want to delete?'),
              actions: <Widget>[
                SingleChildScrollView(
                    child: Form(
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _verifyPIN(milkRecord.id.toString(),
                                                _pinController.text, context);
                                          }
                                        }),
                                  ])
                            ])))
              ]);
        });
  }

  /// Update Milk Volume Pumped Data.
  ///
  /// Params [key], [title], [leftBreast], [rightBreast], [totalVolume], and [timestamp] to update the database.
  void _updateData(
      String id, String title, String leftBreast, String rightBreast) async {
    var left = double.parse(leftBreast);
    var right = double.parse(rightBreast);
    var totalVolume = (left + right).toString();

    FirebaseFirestore.instance
        .collection('milk')
        .doc(email)
        .collection('records')
        .doc(id)
        .update({
      "title": title,
      "leftBreast": leftBreast,
      "rightBreast": rightBreast,
      "totalVolume": totalVolume,
      "timestamp": DateTime.now()
    });
  }

  /// Delete Milk Volume Pumped Data. [Admin]
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
          .collection('milk')
          .doc(email)
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
