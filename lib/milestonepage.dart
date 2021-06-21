import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';



class MilestonePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double c_width = MediaQuery.of(context).size.width*0.9;
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
    return Material(
      child: Container(
        color: Color(0xff4C52A8),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 80,
                left: 30,
                child: Text(
                    "Welcome Address",
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
              child: new Image.asset('assets/healthcare.png', width: 140.0),
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
                child: new Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0,40.0,0.0,0.0),

                        child: Text(
                            "Dear Parents",
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: MediaQuery.of(context).size.width * 0.4,
                      child: new Image.asset('assets/heart.png', width: MediaQuery.of(context).size.width * 0.2),
                    ),

                    Positioned(
                      top: 80,
                      left: MediaQuery.of(context).size.width * 0.4,
                      child: new Image.asset('assets/heart.png', width: MediaQuery.of(context).size.width * 0.2),
                    ),
                    Positioned(
                      left: 22,
                        top: 180,
                        child: new Container (
                      padding: const EdgeInsets.all(8.0),
                      width: c_width,
                      child: new Column (
                        children: <Widget>[
                          new Text ("Congratulations on the birth of your baby! We would like to welcome you to the Neonatal Intensive Care Unit (NICU) at the Khoo Teck Puat- National University Children’s Medical Institute.",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0,12.0,0.0,0.0),
                            child: new Text ("We understand that this is a challenging and exciting time for your family. The NICU can be an overwhelming place. At first glance, all you may see are rows of incubators or warmers, tubes and wires attached to your baby, and hear alarms beeping. The amount of equipment surrounding your baby may appear frightening and with each beep of the alarm, you worry that something is not right with your baby. Our NICU staff are specially trained to interpret and respond to any concerning alarms and can explain to you what they mean. Over time, you too will begin to distinguish and understand the various alarm sounds. ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    )
                    ),

                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
