import 'dart:ffi';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:growth_app/growthpage.dart';
import 'package:growth_app/nav.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AddMeasurements extends StatefulWidget {
  @override
  _AddMeasurementsPageState createState() => _AddMeasurementsPageState();
}

class _AddMeasurementsPageState extends State<AddMeasurements> {

  // Firebase initialisation
  final firebaseDB = FirebaseDatabase.instance.reference();

  String date = '';
  double weight = 0;
  double height = 0;
  double head = 0;

  final _formKey = GlobalKey<FormState>();
  final format = DateFormat("dd-MM-yyyy");

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
              child: Text(
                  "Add Measurements",
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
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0,50.0,40.0,20.0),
                      child: DateTimeField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(25),
                            ),
                          ),
                          labelText: 'Date',
                        ),
                        format: format,
                        onShowPicker: (context, currentValue) {
                        return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                        },
                        onChanged: (val) {
                          setState(() => date);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0,0.0,40.0,20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(25),
                            ),
                          ),
                          labelText: 'Weight (kg)',
                        ),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                        ],
                        validator: (val) => val!.isEmpty ? 'Enter weight in kg' : null,
                        onChanged: (val) {
                          setState(() => weight = val as double);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0,0.0,40.0,20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(25),
                            ),
                          ),
                          labelText: 'Height (cm)',
                        ),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                        ],
                        validator: (val) => val!.isEmpty ? 'Enter height in cm' : null,
                        onChanged: (val) {
                          setState(() => height = val as double);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0,0.0,40.0,20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(25),
                            ),
                          ),
                          labelText: 'Head Circumference (cm)',
                        ),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                        ],
                        validator: (val) => val!.isEmpty ? 'Enter head circumference in cm' : null,
                        onChanged: (val) {
                          setState(() => head = val as double);
                        },
                      ),
                    ),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(child: Padding(
                              padding: const EdgeInsets.fromLTRB(80.0,20.0,80.0,0.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple,
                                  minimumSize: Size(50,50),
                                  //shape: shape,
                                ),
                                child: new Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  if(_formKey.currentState!.validate()){
                                    print('Submit');
                                    Navigator.push(context, new MaterialPageRoute(
                                        builder: (context) => GrowthPage()
                                    ));
                                  }
                                },
                              )
                          ))

                        ]
                    ),
                  ]
                  ),
                )
            ),
          )
        ],
      ),
    ),
    );
  }
}
