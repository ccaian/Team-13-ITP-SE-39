import 'package:flutter/material.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChildProfilePage extends StatefulWidget {
  _ChildProfilePageState createState() => _ChildProfilePageState();
}

/// User Profile Page state for users to view and update their personal details.
class _ChildProfilePageState extends State<ChildProfilePage> {
  /// Private Variables
  var _childName, _gestationDate, _gender;

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  /// Firebase reference for user collection
  final _childReference = FirebaseFirestore.instance.collection('child');

  /// to ensure certain function is execute before page load for certain data
  @override
  void initState() {
    retrieveData().then((List value) {
      value.forEach((element) {
        setState(() {
          _childName = element['name'];
          _gestationDate = formatter.format(element['gestationDate'].toDate()).toString();
          _gender = toBeginningOfSentenceCase(element['gender']);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            color: mainTheme,
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: <Widget>[
              Positioned(
                  top: 80,
                  left: 30,
                  child: Text("Child's Profile",
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ))),
              Positioned(
                top: 40,
                right: -10,
                child: new Image.asset('assets/healthcare.png', width: 140.0),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.77,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25.0),
                          topLeft: Radius.circular(25.0)),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                40.0, 0.0, 40.0, 20.0),
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: _childName),
                              enabled: false,
                              decoration: InputDecoration(
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(25),
                                  ),
                                ),
                                labelText: 'Child Name',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                40.0, 0.0, 40.0, 20.0),
                            child: TextFormField(
                              controller: TextEditingController(text: _gender),
                              enabled: false,
                              decoration: InputDecoration(
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(25),
                                  ),
                                ),
                                labelText: 'Gender',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                40.0, 0.0, 40.0, 20.0),
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: _gestationDate),
                              enabled: false,
                              decoration: InputDecoration(
                                fillColor: Colors.grey,
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(25),
                                  ),
                                ),
                                labelText: 'Gestation Date',
                              ),
                            ),
                          ),
                        ]),
                  ))
            ])));
  }

  /// Function is for retrieving the user's personal details before page load.
  Future<List> retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var nric = prefs.getString('ChildNRIC');
    print(nric);
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _childReference.where('nric', isEqualTo: nric).get();
    List child = snapshot.docs;
    return child;
  }
}
