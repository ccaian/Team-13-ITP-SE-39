import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growth_app/model/development_domain.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DevelopmentDomainCard extends StatelessWidget {
  final isAdmin;

  const DevelopmentDomainCard({
    Key? key,
    required this.developmentDomainRecord,
    required this.isAdmin,
  }) : super(key: key);

  final DevelopmentDomain developmentDomainRecord;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Card(
        child: Container(
      padding: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
            child: Container(
              child: Text("Title: " + developmentDomainRecord.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                "Description: \n" + developmentDomainRecord.description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          SizedBox(
            width: 0,
            height: 40,
          ),
          !isAdmin
              ? const SizedBox.shrink()
              : TextButton(
                  onPressed: () {
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
                      Text('Update',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
          SizedBox(
            width: 20,
            height: 40,
          ),
          !isAdmin
              ? const SizedBox.shrink()
              : TextButton(
                  onPressed: () {
                    deleteDialog(context);
                  },
                  child: Row(children: [
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
                  ])),
        ]),
      ]),
    ));
  }

  void updateDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _titleController =
        TextEditingController(text: developmentDomainRecord.title);
    final _descriptionController =
        TextEditingController(text: developmentDomainRecord.description);
    String _title = '';
    String _description = '';

    var alert = AlertDialog(
      title: Text("Editing \"" +
          developmentDomainRecord.title +
          "\" Development Domain"),
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(25),
                      ),
                    ),
                    fillColor: secondaryTheme,
                    labelText: 'Title',
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter a Title' : null,
                  controller: _titleController,
                ),
                SizedBox(height: 10),
                TextFormField(
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25),
                        ),
                      ),
                      fillColor: secondaryTheme,
                      labelText: 'Description',
                    ),
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a description' : null,
                    controller: _descriptionController,
                    maxLines: 5,
                    minLines: 3),
                Row(
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
                          child: Text('Submit'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _updateData(
                                  developmentDomainRecord.id.toString(),
                                  _titleController.text,
                                  _descriptionController.text);
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          }),
                    ]),
              ],
            ),
          ),
        ],
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void deleteDialog(BuildContext context) {
    final _pinController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    var alert = AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete?'),
        actions: <Widget>[
          Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
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
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your Admin PIN' : null,
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
                              verifyPIN(developmentDomainRecord.id.toString(),
                                  _pinController.text, context);
                            }
                          }),
                    ])
              ]))
        ]);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void _updateData(String key, String title, String description) async {
    FirebaseFirestore.instance
        .collection('developmentdomain')
        .doc(key)
        .update({'title': title, 'description': description});
  }

  void verifyPIN(String key, String pin, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var adminPin = prefs.getString('adminPin').toString();
    var pinBytes = utf8.encode(pin); // data being hashed
    var hashedPin = sha256.convert(pinBytes).toString(); // Hashing Process

    if (adminPin == hashedPin) {
      FirebaseFirestore.instance
          .collection('developmentdomain')
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
      print("Invalid Admin PIN");
    }
  }
}
