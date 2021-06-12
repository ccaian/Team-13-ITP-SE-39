import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/addmeasurements.dart';
import 'package:growth_app/nav.dart';



class GrowthPage extends StatefulWidget{
  @override
  _GrowthPageState createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {

  // Firebase initialisation
  final firebaseDB = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff4C52A8),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 80,
              left: 30,
              child: Text(
                  "Baby Name",
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
                child: Stack(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => AddMeasurements()
                        ));
                      },
                      child: const Text('+ Add Measurements'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0,50.0,0.0,0.0),
                      child: DataTable (
                        columnSpacing: 40.0,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Date',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Weight',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Height',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Head',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                        rows: const <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('2021-06-10')),
                              DataCell(Text('4.4 kg')),
                              DataCell(Text('54.6 cm')),
                              DataCell(Text('34.2 cm')),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('2021-06-11')),
                              DataCell(Text('4.6 kg')),
                              DataCell(Text('54.7 cm')),
                              DataCell(Text('34.3 cm')),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('2021-06-12')),
                              DataCell(Text('4.7 kg')),
                              DataCell(Text('54.8 cm')),
                              DataCell(Text('34.4 cm')),
                            ],
                          ),
                        ],
                      )
                    )
                  ],
                ),
            ),
          )
        ],
      ),
    );
  }
}
