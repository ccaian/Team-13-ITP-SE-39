import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/workerhome.dart';



class WorkerSelFamily extends StatelessWidget {
  List<String> litems = ["Lim","Miranda","Tan","Ian"];
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
                  "Select Family",
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
              child:Scaffold(
                body: new ListView.builder
                  (padding: const EdgeInsets.all(8),
                    itemCount: litems.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new GestureDetector( //You need to make my child interactive
                        onTap: () {
                          Navigator.pop(context, litems[index]);
                        },
                        child: new Card( //I am the clickable child
                          color: Colors.grey,
                          child: new Column(
                            children: <Widget>[
                              //new Image.network(video[index]),
                              new Padding(padding: new EdgeInsets.all(16.0)),
                              new Text(litems[index],
                                style: new TextStyle(fontWeight: FontWeight.bold,
                                    color: Colors.black, fontSize: 20),
                              ),


                            ],
                          ),),
                      );
                        //new Text(litems[index]);
                    }
                )

              ),
            ),
          )
        ],
      ),
    );

  }

}
