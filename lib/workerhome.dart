import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';



class WorkerHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
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
                  "Welcome,\nJia Ming",
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
                child: Stack(
                    children: <Widget>[
                    Positioned(
                    top: MediaQuery.of(context).size.width * 0.07,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Color(0xff4C52A8),

                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25),
                          ),
                        ),
                      )
                    ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.13,
                          left: MediaQuery.of(context).size.width * 0.11,

                          child: Text(
                              "Currently Managing\nMiranda Family",
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )
                          )
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.28,
                          left: MediaQuery.of(context).size.width * 0.11,

                          child: Text(
                              "Enter information here",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              )
                          )
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.width * 0.45,
                          left: MediaQuery.of(context).size.width * 0.10,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              minimumSize: Size(50,50),
                              shape: shape,
                            ),
                            child: new Text(
                              "     Change Patient      ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),

                            ),
                            onPressed: () {

                              print('pressed log in');
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => Nav()
                              ));
                            },
                          )
                      )
                    ]

                )
            ),
          )
        ],
      ),
    );
  }
}
