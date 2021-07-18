import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMeasurements extends StatefulWidget {
  String growthKey;
  EditMeasurements({required this.growthKey});

  @override
  _EditMeasurementsPageState createState() => _EditMeasurementsPageState();
}

class _EditMeasurementsPageState extends State<EditMeasurements> {
  late TextEditingController _dateControl, _weightControl, _heightControl, _headControl;
  late DatabaseReference _growthRef;

  @override
  void initState() {
    super.initState();
    _dateControl = TextEditingController();
    _weightControl = TextEditingController();
    _heightControl = TextEditingController();
    _headControl = TextEditingController();
    _growthRef = FirebaseDatabase.instance.reference().child('growth');
    getGrowthDetail();
  }

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
                    "Edit Measurements",
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
                          controller: _dateControl,
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
                          controller: _weightControl,
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
                          controller: _heightControl,
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
                          controller: _headControl,
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

                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      var nric = prefs.getString('ChildNRIC');

                                      editData(nric, date, weight, height, head);
                                    }
                                    else {
                                      Fluttertoast.showToast(
                                          msg: "Please fill in all required fields.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
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

  Future<void> getGrowthDetail() async {
    DataSnapshot snapshot = await _growthRef.child(widget.growthKey).once();

    Map growth = snapshot.value;
    _dateControl.text = growth['name'];
    _weightControl.text = growth['weight'];
    _heightControl.text = growth['height'];
    _headControl.text = growth['head'];

    //setState(() {});
  }

  void editData(nric, date, weight, height, head) async{
    date = _dateControl.text;
    weight = _weightControl.text;
    height = _heightControl.text;
    head = _headControl.text;

    Map<String, String> growth = {
      //'date': date,
      'weight':  weight,
      'height': height,
      'head': head,
    };

    _growthRef.child(widget.growthKey).update(growth).then((value) {
      Navigator.pop(context);
    });
  }
}