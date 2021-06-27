import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/milestoneguidance.dart';
import 'package:growth_app/parenthome.dart';
import 'package:growth_app/register.dart';
import 'package:growth_app/workerhome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('start');
  var email = prefs.getString('email');
  if (email != null) {
    print(email);
    if(email == 'darrellerjr@gmail.com') {
      MaterialApp(
        title: 'Growth App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily:  'Roboto'),
        home: WorkerHome(),
      );
    }
    else {
      MaterialApp(
        title: 'Growth App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily:  'Roboto'),
        home: ParentHome(),
      );
    }
  }
  runApp(GrowthApp());
}

class GrowthApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Growth App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily:  'Roboto'),
        home: LandingPage(), // change to parent home when done
      );
    }
}

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final shape = RoundedRectangleBorder(
      borderRadius:  BorderRadius.circular(25)
    );
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset('assets/splashimage.png', width: 300.0),

              ]
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,32.0,8.0,8.0),
                      child: new Text(
                        "Track Your Baby",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        )
                      )
                  ),

                ]
            ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                          "Share your babies growth journey with your \nhealthcare worker and keep each other in touch",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[700],
                          )
                      )
                  ),

                ]
            ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Padding(
                    padding: const EdgeInsets.fromLTRB(80.0,20.0,80.0,0.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        minimumSize: Size(50,50),
                        shape: shape,
                      ),
                      child: new Text(
                          "Log In",
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
                          builder: (context) => LoginPage()
                        ));
                      },
                    )
                  ))

                ]
            ), new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Padding(
                      padding: const EdgeInsets.fromLTRB(80.0,0.0,80.0,0.0),
                      child: TextButton(
                        child: new Text(
                          "Register Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[700],
                          ),

                        ),
                        onPressed: () {
                          print('pressed register');
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => RegisterPage()
                          ));
                        },
                      )
                  ))

                ]
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,0.0,15.0,0.0),
                  child: IconButton(
                    icon: const Icon(Icons.announcement_rounded),
                    color: Colors.indigo[500],
                    tooltip: 'Increase volume by 10',
                    onPressed: () {
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => MilestoneGuidance()
                      ));
                    },
                  ),
                ),

              ],

            )
          ]
        ),
      )
    );
  }
}


