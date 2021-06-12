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
                  ],
                ),
            ),
          )
        ],
      ),
    );
  }
}
